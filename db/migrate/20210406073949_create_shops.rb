class CreateShops < ActiveRecord::Migration[6.0]
  def change
    create_table :shops do |t|
      t.string :name
      t.timestamps
    end

    change_table :order_items do |t|
      t.references :shop
    end

    change_table :products do |t|
      t.references :shop
    end
  end
end
