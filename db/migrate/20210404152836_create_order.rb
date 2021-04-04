# frozen_string_literal: true

class CreateOrder < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.integer :amount
      t.integer :quantity
      t.timestamps
    end
  end
end
