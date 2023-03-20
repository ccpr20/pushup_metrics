class ChangeAmountToIntegerInPushups < ActiveRecord::Migration[5.1]
  def change
    change_column :pushups, :amount, 'integer USING CAST(amount AS integer)'
  end
end
