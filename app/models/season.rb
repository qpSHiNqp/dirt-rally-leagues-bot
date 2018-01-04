class Season < ApplicationRecord
  has_many :events
  belongs_to :league
  def open_at
    self.events.map {|e| e.open_at}.min
  end
  def close_at
    self.event.map {|e| e.close_at}.max
  end
  def current_event
    self.events.select {|e| e.open_at <= Time.now && Time.now <= e.close_at }
  end
end
