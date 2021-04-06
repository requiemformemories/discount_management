class DiscountCalculator
  def initialize(order:, type: , options:, current_value: 0)
    @order = order
    @type = type
    @options = options
    @current_value = current_value
  end

  def calculate
    # TODO: implement ate method of amount, percent, free_shopping, product, total_amount, user_total_amount
    case @type
    when 'amount'
      @current_value + DiscountCalculator::Amount.new(order: @order, options: @options).calculate
    when 'percent'
      @current_value + DiscountCalculator::Percent.new(order: @order, options: @options).calculate
    when 'total_amount_check'
      DiscountCalculator::TotalAmountCheck.new(order: @order, options: @options, current_value: @current_value).calculate
    else
      0
    end
  end
end
