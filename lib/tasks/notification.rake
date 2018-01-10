namespace :notification do
  desc "Notify closing event to registered discord channel"
  task :closing_event => :environment do
    ClosingEventNotificationJob.perform_later
  end
  desc "Notify closed event to registered discord channel"
  task :closed_event => :environment do
    ClosedEventNotificationJob.perform_later
  end
  desc "Notify closed season to registered discord channel"
  task :closed_season => :environment do
    ClosedSeasonNotificationJob.perform_later
  end
  desc "Notify starting event to registered discord channel"
  task :starting_event => :environment do
    StartingEventNotificationJob.perform_later
  end
  desc "Notify starting season to registered discord channel"
  task :starting_season => :environment do
    StartingSeasonNotificationJob.perform_later
  end
end
