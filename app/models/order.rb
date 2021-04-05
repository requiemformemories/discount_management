# frozen_string_literal: true

class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy

  def available_discounts
    Discount.all.filter do |discount|
      case discount.scope.keys[0] # now only one condition is available
      when 'all'
        options = discount.scope['all']
        next if options['amount'] && amount < options['amount']
        next if options['start_at'] && created_at < options['start_at']
        next if options['end_at'] && created_at > options['end_at']
        next if options['quantity'] && quantity < options['quantity']
      when 'product'
        options = discount.scope['product']
        order_item = order_items.find_by(product_id: options['id'])
        next unless order_item
        next if options['quantity'] && order_item.quantity < options['quantity']
      when 'shop', 'user'
        raise 'not implement yet'
      else
        next
      end

      true
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
