class DiscountCalculator
  class Base
    def initialize(order:, discount:)
      @order = order
      @discount = discount
      @options = discount.rules[self.class.name.demodulize.underscore]
    end

    def calculate
      raise '#calculate method should be implemented'
    end
  end
end
