namespace :webhook do
  desc "Register webhook with a league"
  task :register => :environment do |channel_id, url, team_id, league_name|
    league = League.find_or_create_by(team_id: team_id) do |l|
      l.league_name = league_name
    end
    puts league.channels.build(channel_id: channel_id, webhook_url: url).save
  end
end
