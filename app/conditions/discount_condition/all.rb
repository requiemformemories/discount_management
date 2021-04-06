class DiscountCondition
  class All < Base
    def initialize(order: , options:, discount:)
      @order = order
      @options = options
      @discount = discount
    end

    def perform
      return false if @options['amount'] && @order.amount < @options['amount']
      return false if @options['start_at'] && @order.created_at < @options['start_at']
      return false if @options['end_at'] && @order.created_at > @options['end_at']
      return false if @options['quantity'] && @order.quantity < @options['quantity']
      return false if @options['times'] && used_count >= @options['times']
      return false if @options['month_times'] && used_count(:month) >= @options['month_times']

      true
    end

    def used_count(type = nil)
      where_clause = { created_at: Date.current.all_month } if type == :month

      @discount.discount_inventories.where(where_clause).count
    end
  end
end
