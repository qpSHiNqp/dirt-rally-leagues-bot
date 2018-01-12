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
  def completed_event_num
    events.order(open_at: :ASC).pluck(:event_id).index(current_event.event_id)
  end
  def to_s
    self.standing.to_s
  end
end
