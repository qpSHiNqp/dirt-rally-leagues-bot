class ChangeColumnTypeToStageLeaderboards < ActiveRecord::Migration[5.1]
  def up
    change_column :stage_leaderboards, :content, :text
  end
  def down
    change_column :stage_leaderboards, :content, :string
  end
end
