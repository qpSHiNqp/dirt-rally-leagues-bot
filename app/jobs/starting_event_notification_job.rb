class StartingEventNotificationJob < ApplicationJob
  queue_as :default

  def perform()
    # Find events starting within the next 1.day
    starting_events = Event.where(open_at: Time.zone.now..1.day.from_now)
    bot = Discordrb::Bot.new token: Rails.configuration.discord['token']

    starting_events.each do |event|
      hours = ((event.open_at - Time.zone.now) / 1.hour).floor
      minutes = (((event.open_at - Time.zone.now) - hours * 1.hour) / 1.minute).round
      event.season.league.channels.each do |ch|
        bot.send_message(ch.channel_id, "あと#{hours}時間#{minutes}分で#{event.title} (#{event.countries})が始まります\n" +
        Rails.application.routes.url_helpers.season_url(event.season))
      end
    end
  end
end
