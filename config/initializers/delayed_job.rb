Delayed::Worker.max_run_time = 3.minutes
Delayed::Worker.logger = Logger.new(File.join(Rails.root, 'log', 'jobs.log'))
