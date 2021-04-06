class DiscountCalculator
  class Base
    def initialize(order:, options:)
      @order = order
      @options = options
    end

    def calculate
      raise '#calculate method should be implemented'
    end
  end
end
