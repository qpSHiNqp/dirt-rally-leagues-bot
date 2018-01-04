namespace :crawler do
  namespace :seasons do
    desc "Sync season events and leaderboard"
    task :sync => :environment do
      SeasonUpdateJob.perform_later
      #LeaderboardUpdateJob.perform_later
    end
  end
end
