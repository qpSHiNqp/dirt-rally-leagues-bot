require 'json'

class SeasonStanding < ApplicationRecord
  belongs_to :season
  def to_string
    JSON.parse(self.content).map {|e|
      "#{e['Position'].to_s.rjust(2)}, #{e['Name'].ljust(12)}, #{e['VehicleName'].ljust(24)}, #{e['Time'].ljust(18)}, #{e['DiffFirst'].ljust(16)}"
    }.join("\n")
  end
end
