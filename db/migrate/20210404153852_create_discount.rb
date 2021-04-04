# frozen_string_literal: true

class CreateDiscount < ActiveRecord::Migration[6.0]
  def change
    create_table :discounts do |t|
      t.jsonb :scope, default: {}, null: false
      t.jsonb :rules, default: {}, null: false
      t.timestamps
    end
  end
end
