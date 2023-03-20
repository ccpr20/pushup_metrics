class AddTimeZoneToReminders < ActiveRecord::Migration[5.1]
  def change
    add_column :reminders, :time_zone, :string
  end
end
