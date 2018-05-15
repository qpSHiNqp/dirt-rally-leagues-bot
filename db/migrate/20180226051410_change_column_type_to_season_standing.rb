class ChangeColumnTypeToSeasonStanding < ActiveRecord::Migration[5.1]
  def up
    change_column :season_standings, :content, :text
  end
  def down
    change_column :season_standings, :content, :string
  end
end
