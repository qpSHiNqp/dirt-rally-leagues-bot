require 'discordrb'

if defined?(Rails::Server)

  bot = Discordrb::Commands::CommandBot.new token: Rails.configuration.discord['token'], client_id: Rails.configuration.discord['client_id'], prefix: "/"

  bot.command(:register,
              min_args: 0,
              max_args: 2,
              description: 'リーグをDiscordチャンネルに登録します。チャンネル名が "TeamID_LeagueName" の形式になっているのが好ましいですが、パラメータでも指定可能です',
              usage: 'register [TeamId] [LeagueName]') do |event, team_id, league_name|
    info = event.channel.name.split("_")
    team_id     = info[0] unless team_id
    league_name = info[1] unless league_name

    league = League.find_or_create_by(team_id: team_id) do |l|
      l.league_name = league_name
    end
    unless league.channels.exists?(channel_id: event.channel.id)
      league.channels.build(channel_id: event.channel.id).save
    end
    SeasonUpdateJob.perform_later
    SeasonStandingUpdateJob.perform_later
    EventLeaderboardUpdateJob.perform_later
    "Registered notification for #{league_name} league"
  end

  bot.command(:season,
              min_args: 0,
              max_args: 1,
              description: 'シーズン情報を表示します',
              usage: 'season [season_id]') do |event, season_id|
    if season_id.present? and Season.exists?(season_id: season_id)
      season = Season.find_by(season_id: season_id)
      "#{season.open_at} 〜 #{season.close_at} シーズンのポイントランキング:\n" +
      "```#{season.to_s}```"
    elsif Channel.exists?(channel_id: event.channel.id)
      begin
        season = Channel.find_by(channel_id: event.channel.id).league.current_season
        "現在開催中のシーズン (#{season.open_at} 〜 #{season.close_at})\n" +
        "全#{season.events.count}戦中#{season.events.order(open_at: :ASC).pluck(:event_id).index(season.current_event.event_id)}戦終了時点でのポイントランキング:\n" +
        "```#{season.to_s}```"
      rescue NoMethodError
        "現在開催中のシーズンはありません"
      end
    else
      "シーズン情報が見つかりませんでした。/registerコマンドでBotを登録してからイベント情報が更新されるまでに時間がかかる場合があります"
    end
  end

  bot.command(:event,
             min_args: 0,
             max_args: 1,
             description: 'イベント情報を表示します',
             usage: 'event [event_id]') do |event, event_id|
    if event_id.present? and Event.exists?(event_id: event_id)
      event = Event.find_by(event_id: event_id)
      "#{event.open_at} 〜 #{event.close_at} 開催の #{event.title} (#{event.countries}) の順位は\n" +
      "```#{event.to_s}```"
    elsif Channel.exists?(channel_id: event.channel.id)
      begin
        event = Channel.find_by(channel_id: event.channel.id).league.current_season.current_event
        "現在の#{event.title} (#{event.countries}) は#{event.open_at} 〜 #{event.close_at}の期間で開催されています. 現在の完走者順位:\n" +
        "```#{event.to_s}```"
      rescue NoMethodError
        "現在開催中のイベントはありません"
      end
    else
      "イベント情報が見つかりませんでした。/registerコマンドでBotを登録してからイベント情報が更新されるまでに時間がかかる場合があります"
    end
  end

  bot.run :async
end
