# frozen_string_literal: true

class Discount < ApplicationRecord
  def calculate(order, discount = 0)
    # TODO: implement caculate method of amount, percent, free_shopping, product, total_amount, user_total_amount
    discount += rules['amount'] if rules['amount']
    discount += rules['percent'] * order.amount * 0.01 if rules['percent']
    discount = rules['total_amount_check'] if rules['total_amount_check'] && rules['total_amount_check'] < discount
    discount
  end
end
