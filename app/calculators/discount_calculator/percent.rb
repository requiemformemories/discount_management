class DiscountCalculator
  class Percent < Base
    def calculate
      return (@options * @order.amount * 0.01).to_i if @options.is_a? Integer
      return (@options['value'] * order_item.amount * 0.01).to_i if order_item

      0
    end

    def order_item
      return unless @options['product_id']

      @order_item ||= @order.order_items.find_by(product_id: @options['product_id'])
    end
  end
end
