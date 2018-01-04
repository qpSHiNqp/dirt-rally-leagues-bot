class CreateChannels < ActiveRecord::Migration[5.1]
  def change
    create_table :channels, :primary_key => :channel_id do |t|
      t.references :league

      t.timestamps
    end
  end
end
