# frozen_string_literal: true

class Discount < ApplicationRecord
  def calculate(order, discount = 0)
    rules.each do |type, options|
      discount = DiscountCalculator.new(order: order, type: type, options: options, current_value: discount).calculate
    end

    discount
  end
end
