class AddHideProfileToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :hide_profile, :boolean, :default => false
  end
end
