namespace :events do
  desc "Announce ongoing events to channels"
  task current: :environment do
    CurrentEventNotificationJob.perform_later
  end
end
