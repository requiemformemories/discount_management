class DiscountCalculator
  class Amount < Base
    def calculate
      return @options if @options.is_a? Integer
      return remaining if @options['total_amount_check']

      0
    end

    def remaining
      current_total = @discount.discount_inventories.sum(&:amount)
      return @options['value'] if @options['total_amount_check'] - current_total >= @options['value']

      @options['total_amount_check'] - current_total
    end
  end
end
