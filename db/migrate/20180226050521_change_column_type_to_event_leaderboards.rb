class ChangeColumnTypeToEventLeaderboards < ActiveRecord::Migration[5.1]
  def up
    change_column :event_leaderboards, :content, :text
  end
  def down
    change_column :event_leaderboards, :content, :string
  end
end
