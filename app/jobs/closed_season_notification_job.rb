class ClosedSeasonNotificationJob < ApplicationJob
  queue_as :default

  def perform()
    # Find seasons closed within the last 1.hour
    closed_seasons = Event.where(close_at: 1.hour.ago..Time.zone.now).select {|event|
      1.hour.ago <= event.season.close_at and event.season.close_at <= Time.zone.now
    }.map{|event| event.season}

    closed_seasons.each do |season|
      season.league.channels.each do |ch|
        Leagues::Discord.bot.send_message(ch.channel_id, "#{season.league.league_name}のシーズンが終了しました\n" +
        "順位:\n" +
        "```#{season.standing.to_s}```\n" +
        Rails.application.routes.url_helpers.season_url(season));
      end
    end
  end
end
