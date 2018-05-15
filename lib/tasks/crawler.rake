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

  namespace :events do
    namespace :daily1 do
    end
    namespace :daily2 do
    end
    namespace :weekly1 do
    end
    namespace :weekly2 do
    end
    namespace :monthly do
    end
  end
end
