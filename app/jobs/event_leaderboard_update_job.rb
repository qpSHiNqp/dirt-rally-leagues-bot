require 'json'
require 'open-uri'

class EventLeaderboardUpdateJob < ApplicationJob
  queue_as :default

  def perform(event)
    url = "https://www.dirtgame.com/uk/api/event?eventId=#{event.event_id}" +
      "&leaderboard=true&stageId=0&number=100"
    json = open(url) do |f|
      f.read
    end
    page = 1
    entries = []
    data = JSON.parse(json)
    entries.concat(data["Entries"])
    while (data["Pages"] - page) > 0 do
      page += 1
      url = "https://www.dirtgame.com/uk/api/event?eventId=#{event.event_id}" +
        "&leaderboard=true&stageId=0&number=100"
      json = open(url) do |f|
        f.read
      end
      entries.concat(JSON.parse(json)["Entries"])
    end

    event.build_leaderboard unless event.leaderboard
    event.leaderboard.update(content: entries.to_json)
  end
end
