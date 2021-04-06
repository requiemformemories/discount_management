# frozen_string_literal: true

class DiscountCondition
  def initialize(order:, discount:)
    @order = order
    @discount = discount
  end

  def perform
    case @discount.scope.keys[0]
    when 'all'
      DiscountCondition::All.new(order: @order, options: @discount.scope['all']).perform
    when 'product'
      DiscountCondition::Product.new(order: @order, options: @discount.scope['product']).perform
    when 'shop'
      DiscountCondition::Shop.new(order: @order, options: @discount.scope['shop']).perform
    else
      false
    end
  end
end
