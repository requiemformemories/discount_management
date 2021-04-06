class DiscountCondition
  class All < Base
    def initialize(order: , options:)
      @order = order
      @options = options
    end

    def perform
      return false if @options['amount'] && @order.amount < @options['amount']
      return false if @options['start_at'] && @order.created_at < @options['start_at']
      return false if @options['end_at'] && @order.created_at > @options['end_at']
      return false if @options['quantity'] && @order.quantity < @options['quantity']

      true
    end
  end
end
