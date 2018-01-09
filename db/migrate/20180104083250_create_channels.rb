class CreateChannels < ActiveRecord::Migration[5.1]
  def change
    create_table :channels do |t|
      t.string :channel_id
      t.references :league

      t.timestamps
    end
  end
end
