class CreateStageLeaderboards < ActiveRecord::Migration[5.1]
  def change
    create_table :stage_leaderboards do |t|
      t.string :content
      t.integer :stage_id
      t.references :event

      t.timestamps
    end
  end
end
