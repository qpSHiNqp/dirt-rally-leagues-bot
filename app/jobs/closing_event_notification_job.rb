class ClosingEventNotificationJob < ApplicationJob
  queue_as :default

  def perform()
    # Find events closing within 24.hours
    closing_events = Event.where(close_at: Time.zone.now..1.days.from_now)

    closing_events.each do |event|
      hours = ((event.close_at - Time.zone.now) / 1.hour).floor
      minutes = (((event.close_at - Time.zone.now) - hours * 1.hour) / 1.minute).floor
      event.season.league.channels.each do |ch|
        Leagues::Discord.bot.send_message(ch.channel_id, "あと#{hours}時間#{minutes}分で#{event.title} (#{event.countries})が終了します\n" +
        "現在の完走者と順位:\n" +
          "```#{event.leaderboard.content.length > 0 ? event.leaderboard.to_s : 'まだ完走者はいません'}```\n" +
        Rails.application.routes.url_helpers.season_url(event.season) + "##{event.title.gsub(' ', '')}")
      end
    end
  end
end
