require 'open-uri'
require 'nokogiri'

class SeasonUpdateJob < ApplicationJob
  queue_as :default

  def perform(*args)
    logger.debug "Job!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    League.all.each do |l|
      url = "https://www.dirtgame.com/uk/leagues/league/#{l.team_id}/#{l.league_name}"
      charset = nil
      html = open(url) do |f|
        charset = f.charset
        f.read
      end
      doc = Nokogiri::HTML.parse(html, nil, charset)

      node = doc.css('div[data-ng-show="season == \'current\'"]')
      season_id = node.css('div.league_season_schedule').attribute('data-ng-init')
                      .text.split(' ')[2]
      events = node.css('select#eventid > option').map {|opt| opt.attribute('value').text}
      season = Season.find_or_create_by(season_id: season_id) do |s|
        s.league = l
      end
      events.each do |e|
        season.events.find_or_create_by(event_id: e) do |evt|
          # DO NOTHING here
        end
      end
      season.save

      node = doc.css('div[data-ng-show="season == \'next\'"]')
      season_id = node.css('div.league_season_schedule').attribute('data-ng-init')
                      .text.split(' ')[2]
      events = node.css('select#eventid > option').map {|opt| opt.attribute('value').text}
      season = Season.find_or_create_by(season_id: season_id) do |s|
        s.league = l
      end
      events.each do |e|
        season.events.find_or_create_by(event_id: e) do |evt|
          # DO NOTHING here
        end
      end
      season.save
    end
  end
end
