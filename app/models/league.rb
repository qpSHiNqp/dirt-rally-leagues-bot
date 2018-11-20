class League < ApplicationRecord
  has_many :channels
  has_many :seasons
  def current_season
    self.seasons.select {|e| e.open_at <= Time.now && Time.now <= e.close_at }.last
  end
  def next_season
    self.seasons.select {|e| Time.now < e.open_at }.first
  end
end
