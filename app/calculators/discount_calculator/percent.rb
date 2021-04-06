class DiscountCalculator
  class Percent < Base
    def calculate
      @options * @order.amount * 0.01
    end
  end
end
