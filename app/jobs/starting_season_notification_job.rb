class StartingSeasonNotificationJob < ApplicationJob
  queue_as :default

  def perform()
    # Find seasons that has just started within the last 1.hour
    starting_seasons = Event.where(open_at: 1.hour.ago..Time.zone.now).select {|event|
      Time.zone.now <= event.season.open_at and event.season.open_at <= 1.day.from_now
    }.map{|event| event.season}

    starting_seasons.each do |season|
      season.league.channels.each do |ch|
        Leagues::Discord.bot.send_message(ch.channel_id, "#{season.league.league_name}の新シーズンが始まりました！\n" +
        Rails.application.routes.url_helpers.season_url(season))
      end
    end
  end
end
