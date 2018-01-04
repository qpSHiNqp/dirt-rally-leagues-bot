class CreateLeagues < ActiveRecord::Migration[5.1]
  def change
    create_table :leagues, :primary_key => :team_id do |t|
      t.string :league_name

      t.timestamps
    end
  end
end
