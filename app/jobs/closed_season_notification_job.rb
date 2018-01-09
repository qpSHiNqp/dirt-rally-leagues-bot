class ClosedSeasonNotificationJob < ApplicationJob
  queue_as :default

  def perform()
    # Find seasons closed within the last 1.hour
    closed_seasons = Season.where(close_at: 1.hour.ago..Time.zone.now)
    bot = Discordrb::Bot.new token: Rails.configuration.discord['token']

    closed_seasons.each do |season|
      season.league.channels.each do |ch|
        bot.send_message(ch.channel_id, "#{season.league.league_name}のシーズンが終了しました")
        bot.send_message(ch.channel_id, "順位:\n" + 
                         "```#{season.standing.to_s}```")
      end
    end
  end
end
