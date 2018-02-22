class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.integer :total_price
      t.string :aasm_state

      t.timestamps
    end
  end
end
