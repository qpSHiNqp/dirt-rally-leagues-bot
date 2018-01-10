require 'json'

class EventLeaderboard < ApplicationRecord
  belongs_to :event
  def to_s
    JSON.parse(self.content).map {|e|
      "#{e['Position'].to_s.rjust(2)}, #{e['Name'].ljust(12)}, #{e['VehicleName'].ljust(32)}, #{e['Time'].rjust(10)}, #{e['DiffFirst'].rjust(12)}"
    }.join("\n")
  end
end
