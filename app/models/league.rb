class League < ApplicationRecord
  has_many :seasons
  def current_season
  end
end
