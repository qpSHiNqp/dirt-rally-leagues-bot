require 'open-uri'
require 'nokogiri'

class SeasonUpdateJob < ApplicationJob
  queue_as :default

  def perform(*args)
    League.all.each do |l|
      url = "https://www.dirtgame.com/uk/leagues/league/#{l.team_id}/#{l.league_name}"
      charset = nil
      html = open(url) do |f|
        charset = f.charset
        f.read
      end
      overview_doc = Nokogiri::HTML.parse(html, nil, charset)

      node = overview_doc.css('div[data-ng-show="season == \'current\'"]')
      schedule = node.css('div.league_season_schedule')
      next unless schedule
      season_id = schedule.attribute('data-ng-init')
                      .text.split(' ')[2]
      events = node.css('select#eventid > option').map {|opt|
        {
          event_id: opt.attribute('value').text,
          title:    opt.text
        }
      }
      season = Season.find_or_create_by(season_id: season_id) do |s|
        s.league = l
      end

      charset = nil
      html = open("https://www.dirtgame.com/uk/leagues/view-league-season/#{l.team_id}/current") do |f|
        charset = f.charset
        f.read
      end
      doc = Nokogiri::HTML.parse(html, nil, charset)

      events.each do |e|
        event = season.events.find_or_create_by(event_id: e[:event_id])
        date_range = doc.css("div##{e[:title].downcase.gsub(/ /, "_")} > div.content > div.configuration > div.form_row").first.css('span.value').text.split("-")
        countries = doc.css("div##{e[:title].downcase.gsub(/ /, "_")} > div.content > div.league_season_stages > table > tbody > tr").map do |tr|
          tr.at("td[2]/span").text.split(",")[0]
        end
        last_update = event.updated_at
        event.update(
          title:      e[:title],
          countries:  countries.uniq.join(", "),
          open_at:    Time.parse("#{date_range[0]} +0000").in_time_zone,
          close_at:   Time.parse("#{date_range[1]} +0000").in_time_zone
        )
        EventLeaderboardUpdateJob.perform_later(event) if event.close_at >= last_update
      end
      season.save

      node = overview_doc.css('div[data-ng-show="season == \'next\'"]')
      season_id = node.css('div.league_season_schedule').attribute('data-ng-init')
                      .text.split(' ')[2]
      events = node.css('select#eventid > option').map {|opt|
        {
          event_id: opt.attribute('value').text,
          title:    opt.text
        }
      }
      season = Season.find_or_create_by(season_id: season_id) do |s|
        s.league = l
      end

      charset = nil
      html = open("https://www.dirtgame.com/uk/leagues/view-league-season/#{l.team_id}/pending") do |f|
        charset = f.charset
        f.read
      end
      doc = Nokogiri::HTML.parse(html, nil, charset)

      events.each do |e|
        event = season.events.find_or_create_by(event_id: e[:event_id])
        date_range = doc.css("div##{e[:title].downcase.gsub(/ /, "_")} > div.content > div.configuration > div.form_row").first.css('span.value').text.split("-")
        countries = doc.css("div##{e[:title].downcase.gsub(/ /, "_")} > div.content > div.league_season_stages > table > tbody > tr").map do |tr|
          tr.at("td[2]/span").text.split(",")[0]
        end
        event.update(
          title:      e[:title],
          countries:  countries.uniq.join(", "),
          open_at:    Time.parse("#{date_range[0]} +0000").in_time_zone,
          close_at:   Time.parse("#{date_range[1]} +0000").in_time_zone
        )
      end
      season.save
    end
  end
end
