class DiscountCalculator
  class Percent < Base
    def calculate
      return (@options * @order.amount * 0.01).to_i if @options.is_a? Integer
      return (@options['value'] * order_item.amount * 0.01).to_i if @options['product_id']
      return (@options['value'] * order_items.sum(&:amount) * 0.01).to_i if @options['shop_id']
      return remaining if @options['total_amount_check']

      0
    end

    def order_item
      return unless @options['product_id']

      @order_item ||= @order.order_items.find_by(product_id: @options['product_id'])
    end

    def order_items
      return unless @options['shop_id']

      @order_items ||= @order.order_items.where(shop_id: @options['shop_id'])
    end

    def remaining
      current_total = @discount.discount_inventories.sum(&:amount)
      discount_value = (@options['value'] * @order.amount * 0.01).to_i
      return discount_value if @options['total_amount_check'] - current_total >= discount_value

      @options['total_amount_check'] - current_total
    end
  end
end
