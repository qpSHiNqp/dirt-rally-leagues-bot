class CreateEventLeaderboards < ActiveRecord::Migration[5.1]
  def change
    create_table :event_leaderboards do |t|
      t.string :content
      t.references :event

      t.timestamps
    end
  end
end
