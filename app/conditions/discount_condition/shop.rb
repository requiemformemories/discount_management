class DiscountCondition
  class Shop < Base
    def initialize(order: , options:)
      @order_items = order.order_items.where(shop_id: options['id'])
      @options = options
    end

    def perform
      return false unless @order_items
      return false if @options['quantity'] && @order_items.sum(&:quantity) < @options['quantity']

      true
    end
  end
end
