class AddServerNameColumnToChannel < ActiveRecord::Migration[5.1]
  def change
    add_column :channels, :server_name, :string
  end
end
