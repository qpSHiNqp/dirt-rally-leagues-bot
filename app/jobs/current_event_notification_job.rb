class CurrentEventNotificationJob < ApplicationJob
  queue_as :default

  def perform
    bot = Discordrb::Bot.new token: Rails.configuration.discord['token']

    League.all.each do |league|
      e = league.try(:current_season).try(:current_event)
      next if e.blank?

      t = (e.close_at - Time.zone.now).round
      mm, _ = t.divmod(60)
      hh, mm = mm.divmod(60)
      dd, hh = hh.divmod(24)

      url = "#{Rails.application.routes.url_helpers.season_url(e.season)}##{e.title.gsub(' ', '')}"
      content = "あと#{dd}日と#{hh}時間#{mm}分で#{e.title} (#{e.countries})が終了します"

      if e.leaderboard.content.length > 0
        content += "\n現在の完走者と順位:\n```#{e.leaderboard.to_s}```"
      else
        content += "\nまだ完走者はいません！"
      end

      content += "\n出走忘れのないように、皆さんご参加ください！\n#{url}"

      league.channels.each do |ch|
        Rails.logger.debug "#{league.league_name} announcement to #{ch.channel_id}"
        bot.send_message(ch.channel_id, content)
      end
    end
  end
end
