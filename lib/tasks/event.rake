namespace :event do
  namespace :current do
    desc "Reports current event information"
    task :report => :environment do |channel_id|
      channel = Channel.find_by(channel_id: channel_id)
      puts channel.league.current_season.current_event.to_s
    end
  end
end
