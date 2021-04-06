# frozen_string_literal: true

class Discount < ApplicationRecord
  has_many :discount_inventories, dependent: :nullify

  def calculate(order, discount = 0)
    rules.each do |type, options|
      discount = DiscountCalculator.new(order: order, type: type, options: options, current_value: discount).calculate
    end

    discount
  end

  def use(order)
    discount_inventories.first_or_create(order: order)
  end
end
