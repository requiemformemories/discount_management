class DiscountCalculator
  def initialize(order:, discount: )
    @order = order
    @discount = discount
    @type = @discount.rules.keys[0]
    @options = @discount[@type]
  end

  def calculate
    # TODO: implement calculate method of amount, percent, free_shopping, reward
    case @type
    when 'amount'
      DiscountCalculator::Amount.new(order: @order, discount: @discount).calculate
    when 'percent'
      DiscountCalculator::Percent.new(order: @order, discount: @discount).calculate
    else
      0
    end
  end
end
