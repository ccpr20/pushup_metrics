class AddTermsAndConditionsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :terms_and_conditions, :boolean, :default => true
  end
end
