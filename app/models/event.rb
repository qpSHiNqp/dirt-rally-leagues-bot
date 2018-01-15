class Event < ApplicationRecord
  has_one :leaderboard, :class_name => "EventLeaderboard"
  has_many :stage_leaderboards
  belongs_to :season
  scope :ongoing,   -> { where(["open_at <= ? and close_at > ?", Time.zone.now, Time.zone.now]) }
  scope :completed, -> { where(["close_at <= ?", Time.zone.now]) }
  scope :scheduled, -> { where(["open_at > ?", Time.zone.now]) }

  def ongoing?
    Time.zone.now.between?(open_at, close_at)
  end
  def completed?
    (Time.zone.now > close_at)
  end
  def scheduled?
    (Time.zone.now < open_at)
  end
  def to_s
    self.leaderboard.to_s
  end
end
