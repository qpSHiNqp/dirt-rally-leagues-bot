require 'discordrb'

bot = Discordrb::Commands::CommandBot.new token: "MzkzMzE0NjE3MjY4NjMzNjE5.DR0Ofg.Ta3-j49CjXIlJA0nG3vf3SqfPAA", client_id: "393314617268633619", prefix: "/"

bot.command(:register,
            min_args: 1,
            max_args: 3,
            description: 'リーグをDiscordチャンネルに登録します。チャンネル名が "TeamID_LeagueName" の形式になっているのが好ましいですが、パラメータでも指定可能です',
            usage: 'register [webhookUrl] [TeamId] [LeagueName]') do |event, webhook, team_id, league_name|
  info = event.channel.name.split("_")
  team_id     = info[0] unless team_id
  league_name = info[1] unless league_name
  # TODO insert info into channel table
  # https://discordapp.com/api/webhooks/398787132035956736/43vD0eL26mISp83BkCXQRpExamaeWn6jfFycGtPfyNvdmHs8D9obiNWtAAZ3LfRCUaY9
  `cd #{File.expand_path("../", __FILE__)} && RAILS_ENV=production bundle exec rails webhook:register #{event.channel.id} #{webhook} #{team_id} #{league_name}`
end

bot.command :event do |event, *code|
  `cd #{File.expand_path("../", __FILE__)} && RAILS_ENV=production bundle exec rails event:current:report #{event.channel.id}`
end

bot.command :season do |event, *code|
  `cd #{File.expand_path("../", __FILE__)} && RAILS_ENV=production bundle exec rails season:current:report #{event.channel.id}`
end

bot.run
