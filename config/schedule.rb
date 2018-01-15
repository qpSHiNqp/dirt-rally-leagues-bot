# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
set :output, "/var/log/whenever"

every '14,29,44,59 * * * *' do
  rake "crawler:leaderboard:sync"
end

every :day, :at => '12pm' do
  rake "notification:closing_event"
  rake "notification:starting_season"
  rake "notification:starting_event"
end

every :hour do
  rake "crawler:seasons:sync"
  rake "notification:closed_event"
  rake "notification:closed_season"
end
