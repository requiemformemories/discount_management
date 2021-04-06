class CreateDiscountInventories < ActiveRecord::Migration[6.0]
  def change
    create_table :discount_inventories do |t|
      t.references :order
      t.references :discount
      t.timestamps
    end
  end
end
