class ChangeCreatedAtToDateInPushups < ActiveRecord::Migration[5.1]
  def change
		rename_column :pushups, :created_at, :date
		add_column :pushups, :created_at, :datetime
  end
end
