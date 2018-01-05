namespace :crawler do
  namespace :seasons do
    desc "Sync season configurations"
    task :sync => :environment do
      SeasonUpdateJob.perform_later
    end
  end

  namespace :leaderboard do
    desc "Sync current season's leaderboard"
    task :sync => :environment do
      SeasonStandingUpdateJob.perform_later
    end
  end
end
