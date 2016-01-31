class ChangeAmountToIntegerInPushups < ActiveRecord::Migration
  def change
    change_column :pushups, :amount, 'integer USING CAST(amount AS integer)'
  end
end
