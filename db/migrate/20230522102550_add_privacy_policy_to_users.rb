class AddPrivacyPolicyToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :privacy_policy, :boolean, :default => true
  end
end
