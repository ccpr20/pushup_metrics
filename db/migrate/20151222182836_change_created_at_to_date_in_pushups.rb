class ChangeCreatedAtToDateInPushups < ActiveRecord::Migration
  def change
		rename_column :pushups, :created_at, :date
		add_column :pushups, :created_at, :datetime
  end
end
