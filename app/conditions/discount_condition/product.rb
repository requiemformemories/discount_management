class DiscountCondition
  class Product < Base
    def initialize(order: , options:)
      @order_item = order.order_items.find_by(product_id: options['id'])
      @options = options
    end

    def perform
      return false unless @order_item
      return false if @options['quantity'] && @order_item.quantity < @options['quantity']

      true
    end
  end
end
