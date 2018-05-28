class StartingEventNotificationJob < ApplicationJob
  queue_as :default

  def perform()
    # Find events that has just started within the last 1.hour
    starting_events = Event.where(open_at: 1.hour.ago..Time.zone.now)

    starting_events.each do |event|
      event.season.league.channels.each do |ch|
        Leagues::Discord.bot.send_message(ch.channel_id, "#{event.title} (#{event.countries})が始まりました！皆さんの参戦をお待ちしております。\n" +
        Rails.application.routes.url_helpers.season_url(event.season) + "##{event.title.gsub(' ', '')}")
      end
    end
  end
end
