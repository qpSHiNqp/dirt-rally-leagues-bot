class StartingSeasonNotificationJob < ApplicationJob
  queue_as :default

  def perform()
    # Find seasons starting within the next 1.day
    starting_seasons = Event.where(open_at: Time.zone.now..1.day.from_now).select {|event|
      Time.zone.now <= event.season.open_at and event.season.open_at <= 1.day.from_now
    }.map{|event| event.season}
    bot = Discordrb::Bot.new token: Rails.configuration.discord['token']

    starting_seasons.each do |season|
      hours = ((season.open_at - Time.zone.now) / 1.hour).floor
      minutes = (((season.open_at - Time.zone.now) - hours * 1.hour) / 1.minute).round
      season.league.channels.each do |ch|
        bot.send_message(ch.channel_id, "あと#{hours}時間#{minutes}分で#{season.league.league_name}の次シーズンが始まります\n" +
        Rails.application.routes.url_helpers.season_url(season))
      end
    end
  end
end
