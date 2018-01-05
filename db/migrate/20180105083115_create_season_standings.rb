class CreateSeasonStandings < ActiveRecord::Migration[5.1]
  def change
    create_table :season_standings do |t|
      t.string :content
      t.references :season

      t.timestamps
    end
  end
end
