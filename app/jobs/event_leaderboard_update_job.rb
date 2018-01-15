require 'json'
require 'open-uri'

class EventLeaderboardUpdateJob < ApplicationJob
  queue_as :default

  def perform(event)
    url = "https://www.dirtgame.com/uk/api/event?eventId=#{event.event_id}" +
      "&leaderboard=true&stageId=0"
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
        "&leaderboard=true&stageId=0&page=#{page}"
      json = open(url) do |f|
        f.read
      end
      entries.concat(JSON.parse(json)["Entries"])
    end

    for i in 1..data["TotalStages"]
      page = 1
      stage_entries = []
      url_base = "https://www.dirtgame.com/uk/api/event?eventId=#{event.event_id}&leaderboard=true"
      json = open("#{url_base}&page=#{page}&stageId=#{i}") {|f| f.read }
      data = JSON.parse(json)
      stage_entries.concat(data["Entries"])
      while (data["Pages"] - page) > 0 do
        page += 1
        json = open("#{url_base}&page=#{page}&stageId=#{i}") {|f| f.read }
        stage_entries.concat(JSON.parse(json)["Entries"])
      end
      if event.stage_leaderboards.where(stage_id: i).blank?
        event.stage_leaderboards.build(
          stage_id: i,
          content: stage_entries.to_json,
          location: data["LocationName"],
          location_image: data["LocationImage"],
          stage_name: data["StageName"],
          stage_image: data["StageImage"],
          time_of_day: data["TimeOfDay"],
          weather: data["WeatherText"],
          weather_image: data["WeatherImageUrl"],
          stage_retry: data["StageRetry"],
          has_service_area: data["HasServiceArea"],
          allow_career_engineers: data["AllowCareerEngineers"],
          allow_vehicle_tuning: data["AllowVehicleTuning"],
          is_checkpoint: data["IsCheckpoint"]
                                      ).save
      else
        event.stage_leaderboards.where(stage_id: i).first.update(
          content: stage_entries.to_json,
          location: data["LocationName"],
          location_image: data["LocationImage"],
          stage_name: data["StageName"],
          stage_image: data["StageImage"],
          time_of_day: data["TimeOfDay"],
          weather: data["WeatherText"],
          weather_image: data["WeatherImageUrl"],
          stage_retry: data["StageRetry"],
          has_service_area: data["HasServiceArea"],
          allow_career_engineers: data["AllowCareerEngineers"],
          allow_vehicle_tuning: data["AllowVehicleTuning"],
          is_checkpoint: data["IsCheckpoint"]
        )
      end
    end

    event.build_leaderboard unless event.leaderboard
    event.leaderboard.update(content: entries.to_json)
    event.update(stages: data["TotalStages"].to_i)
  end
end
