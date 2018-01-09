class StartingSeasonNotificationJob < ApplicationJob
  queue_as :default

  def perform()
    # Find seasons starting within the next 1.day
    starting_seasons = Season.where(open_at: Time.zone.now..1.day.from_now)
    bot = Discordrb::Bot.new token: Rails.configuration.discord['token']

    starting_seasons.each do |season|
      hours = ((season.open_at - Time.zone.now) / 1.hour).floor
      minutes = (((season.open_at - Time.zone.now) - hours * 1.hour) / 1.minute).round
      season.league.channels.each do |ch|
        bot.send_message(ch.channel_id, "あと#{hours}時間#{minutes}分で#{season.league.league_name}の次シーズンが始まります")
      end
    end
  end
end
