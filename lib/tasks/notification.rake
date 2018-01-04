namespace :notification do
  desc "Notify closing event to registered discord channel"
  task :closing_event do
    ClosingEventNotificationJob.perform_later
  end
  desc "Notify closed event to registered discord channel"
  task :closed_event do
    ClosedEventNotificationJob.perform_later
  end
  desc "Notify closed season to registered discord channel"
  task :closed_season do
    ClosedSeasonNotificationJob.perform_later
  end
  desc "Notify starting event to registered discord channel"
  task :starting_event do
    StartingEventNotificationJob.perform_later
  end
  desc "Notify starting season to registered discord channel"
  task :starting_season do
    StartingSeasonNotificationJob.perform_later
  end
end
