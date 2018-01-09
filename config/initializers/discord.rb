require 'discordrb'

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

bot.command :season do |event|
  if Channel.exists?(channel_id: event.channel.id)
    "```#{Channel.find_by(channel_id: event.channel.id).league.current_season.to_s}```"
  else
    "No information found. Have you registered the channel with league? Type /register to retrieve league information"
  end
end

bot.command :event do |event|
  if Channel.exists?(channel_id: event.channel.id)
    "```#{Channel.find_by(channel_id: event.channel.id).league.current_season.current_event.to_s}```"
  else
    "No information found. Have you registered the channel with league? Type /register to retrieve league information"
  end
end

bot.run :async

# bot.send_message(channel_id, message)
