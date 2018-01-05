require 'json'

class EventLeaderboard < ApplicationRecord
  belongs_to :event
  def to_string
    JSON.parse(self.content).map {|e|
      "#{e['Position']}, #{e['Name']}, #{e['VehicleName']}, #{e['Time']}, #{e['DiffFirst']}"
    }.join("\n")
  end
end
