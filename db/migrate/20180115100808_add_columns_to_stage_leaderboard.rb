class AddColumnsToStageLeaderboard < ActiveRecord::Migration[5.1]
  def change
    add_column :stage_leaderboards, :location, :string
    add_column :stage_leaderboards, :location_image, :string
    add_column :stage_leaderboards, :stage_name, :string
    add_column :stage_leaderboards, :stage_image, :string
    add_column :stage_leaderboards, :time_of_day, :string
    add_column :stage_leaderboards, :weather, :string
    add_column :stage_leaderboards, :weather_image, :string
    add_column :stage_leaderboards, :stage_retry, :boolean
    add_column :stage_leaderboards, :has_service_area, :boolean
    add_column :stage_leaderboards, :allow_career_engineers, :boolean
    add_column :stage_leaderboards, :allow_vehicle_tuning, :boolean
    add_column :stage_leaderboards, :is_checkpoint, :boolean
  end
end
