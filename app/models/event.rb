class Event < ApplicationRecord
  has_one :leaderboard, :class_name => "EventLeaderboard"
end
