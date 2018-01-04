require 'net/http'
require 'uri'

class LeaderboardUpdateJob < ApplicationJob
  queue_as :default

  def perform(*args)
    League.all.each do |l|
      uri = URI.parse(
        "https://www.dirtgame.com/uk/leagues/league-leaderboard.json" +
        "?teamId=#{l.team_id}&number=100"
      )
      json = Net::HTTP.get(uri)
      l.currentSeason.update(leaderboard: json)
    end
  end
end
