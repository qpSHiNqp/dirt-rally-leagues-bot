class AddWebhookUrlToChannel < ActiveRecord::Migration[5.1]
  def change
    add_column :channels, :webhook_url, :string
  end
end
