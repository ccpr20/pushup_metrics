class CreateReminders < ActiveRecord::Migration
  def change
    create_table :reminders do |t|
      t.string :phone_number
      t.time :time

      t.timestamps null: false
    end
		add_column :reminders, :user_id, :integer
		add_index :reminders, :user_id
  end
end
