require 'open-uri'
require 'json'

class SeasonStandingUpdateJob < ApplicationJob
  queue_as :default

  def perform(*args)
    League.all.each do |l|
      next unless l.current_season

      url = "https://www.dirtgame.com/uk/leagues/league-leaderboard.json" +
            "?teamId=#{l.team_id}"
      json = open(url) do |f|
        f.read
      end
      page = 1
      entries = []
      data = JSON.parse(json)
      entries.concat(data["Entries"])
      while (data["Pages"] - page) > 0 do
        page += 1
        url = "https://www.dirtgame.com/uk/leagues/league-leaderboard.json" +
              "?teamId=#{l.team_id}&page=#{page}"
        json = open(url) do |f|
          f.read
        end
        entries.concat(JSON.parse(json)["Entries"])
      end

      l.current_season.build_standing unless l.current_season.standing
      l.current_season.standing.update(content: entries.to_json)
    end
  end
end
