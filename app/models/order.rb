# frozen_string_literal: true

class Order < ApplicationRecord
  def available_discounts
    Discount.all.filter do |discount|
      case discount.scope.keys[0] # now only one condition is available
      when 'all'
        options = discount.scope['all']
        next if options['amount'] && amount < options['amount']
        next if options['start_at'] && created_at < options['start_at']
        next if options['end_at'] && created_at > options['end_at']
        next if options['quantity'] && quantity < options['quantity']

        true
      when 'product', 'shop', 'user'
        raise 'not implement yet'
      end
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
