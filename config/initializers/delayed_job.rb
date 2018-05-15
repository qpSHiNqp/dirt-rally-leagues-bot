Delayed::Worker.max_run_time = 3.minutes
Delayed::Worker.logger = Logger.new(File.join(Rails.root, 'log', 'jobs.log'))

#system "RAILS_ENV=production #{Rails.root.join('script','delayed_job')} stop"
#system "RAILS_ENV=production #{Rails.root.join('script','delayed_job')} -n 2 start"
