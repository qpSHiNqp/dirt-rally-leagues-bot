class AddCountriesColumnToEvent < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :countries, :string
  end
end
