class Event < ApplicationRecord
  has_one :leaderboard, :class_name => "EventLeaderboard"
  belongs_to :season
  scope :ongoing,   -> { where(["open_at <= ? and close_at > ?", Time.zone.now, Time.zone.now]) }
  scope :completed, -> { where(["close_at <= ?", Time.zone.now]) }
  scope :scheduled, -> { where(["open_at > ?", Time.zone.now]) }

  def to_s
    self.leaderboard.to_s
  end
end
