class Season < ApplicationRecord
  has_many :events
  belongs_to :league
  has_many :channels
  has_one :standing, :class_name => "SeasonStanding"

  def open_at
    self.events.map {|e| e.open_at}.min
  end
  def close_at
    self.events.map {|e| e.close_at}.max
  end
  def current_event
    self.events.select {|e| e.open_at <= Time.now && Time.now <= e.close_at }.first
  end
  def completed?
    (close_at < Time.zone.now)
  end
  def ongoing?
    Time.zone.now.between?(open_at, close_at)
  end
  def completed_event_num
    current_event.present? ?
      events.order(open_at: :ASC).pluck(:event_id).index(current_event.event_id) : 0
  end
  def to_s
    self.standing.to_s
  end
end
