class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events, :primary_key => :event_id do |t|
      t.datetime :open_at
      t.datetime :close_at
      t.references :season

      t.timestamps
    end
  end
end
