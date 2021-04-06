class DiscountCalculator
  class TotalAmountCheck < Base
    def initialize(order:, options:, current_value:)
      @order = order
      @options = options
      @current_value = current_value
    end

    def calculate
      return @options if @options < @current_value

      @current_value
    end
  end
end
