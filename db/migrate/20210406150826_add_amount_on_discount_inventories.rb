class AddAmountOnDiscountInventories < ActiveRecord::Migration[6.0]
  def change
    add_column :discount_inventories, :amount, :integer
  end
end
