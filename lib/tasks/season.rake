namespace :season do
  namespace :current do
    desc "Reports current season information"
    task :report => :environment do |channel_id|
      channel = Channel.find_by(channel_id: channel_id)
      puts channel.league.current_season.to_s
    end
  end
end
