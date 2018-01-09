require 'json'

class SeasonStanding < ApplicationRecord
  belongs_to :season
  def to_s
    "Rank, Player      , Points, SeasonWins\n" +
    JSON.parse(self.content).map {|e|
      "#{e['Rank'].to_s.rjust(4)}, #{e['DisplayName'].ljust(12)}, #{e['PointScore'].to_s.rjust(6)}, #{e['SeasonWins'].to_s.rjust(10)}"
    }.join("\n")
  end
end
