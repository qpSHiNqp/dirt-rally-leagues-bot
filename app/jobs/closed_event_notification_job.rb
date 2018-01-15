class ClosedEventNotificationJob < ApplicationJob
  queue_as :default

  def perform()
    # Find events closed within the last 1.hour
    closed_events = Event.where(close_at: 1.hour.ago..Time.zone.now)
    bot = Discordrb::Bot.new token: Rails.configuration.discord['token']

    closed_events.each do |event|
      event.season.league.channels.each do |ch|
        bot.send_message(ch.channel_id, "#{event.title} (#{event.countries})が終了しました")
        bot.send_message(ch.channel_id, "順位:\n" + 
                         "```#{event.leaderboard.to_s}```")
        bot.send_message(Rails.application.routes.url_helpers.season_url event.season)
      end
    end
  end
end
