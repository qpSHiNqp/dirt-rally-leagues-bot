class CreateSeasons < ActiveRecord::Migration[5.1]
  def change
    create_table :seasons, :primary_key => :season_id do |t|
      t.references :league

      t.timestamps
    end
  end
end
