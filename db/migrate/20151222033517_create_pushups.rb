class CreatePushups < ActiveRecord::Migration
  def change
    create_table :pushups do |t|
      t.string :amount

      t.timestamps null: false
    end
  end
end
