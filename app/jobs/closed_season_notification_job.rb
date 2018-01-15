class ClosedSeasonNotificationJob < ApplicationJob
  queue_as :default

  def perform()
    # Find seasons closed within the last 1.hour
    closed_seasons = Event.where(close_at: 1.hour.ago..Time.zone.now).select {|event|
      1.hour.ago <= event.season.close_at and event.season.close_at <= Time.zone.now
    }.map{|event| event.season}
    bot = Discordrb::Bot.new token: Rails.configuration.discord['token']

    closed_seasons.each do |season|
      season.league.channels.each do |ch|
        bot.send_message(ch.channel_id, "#{season.league.league_name}のシーズンが終了しました")
        bot.send_message(ch.channel_id, "順位:\n" + 
                         "```#{season.standing.to_s}```")
        bot.send_message(Rails.application.routes.url_helpers.season_url season)
      end
    end
  end
end
