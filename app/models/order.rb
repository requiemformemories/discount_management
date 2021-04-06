# frozen_string_literal: true

class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy

  def available_discounts
    Discount.all.filter do |discount|
      DiscountCondition.new(order: self, discount: discount).perform
    end
  end

  def calculate_discounts
    @discount = 0

    available_discounts.each do |discount|
      @discount = discount.calculate(self, @discount)
    end

    @discount
  end
end
