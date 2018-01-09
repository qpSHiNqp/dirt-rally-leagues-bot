class Event < ApplicationRecord
  has_one :leaderboard, :class_name => "EventLeaderboard"
  belongs_to :season

  def to_s
    self.leaderboard.to_s
  end
end
