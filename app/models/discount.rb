# frozen_string_literal: true

class Discount < ApplicationRecord
  has_many :discount_inventories, dependent: :nullify

  def calculate(order)
    DiscountCalculator.new(order: order, discount: self).calculate
  end

  def use(order)
    amount = calculate(order)
    inventory = discount_inventories.where(order: order).first_or_create
    inventory.update(amount: amount)

    amount
  end
end
