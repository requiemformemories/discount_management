class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order

  after_create :update_order

  def update_order
    order.amount += amount
    order.quantity += quantity
    order.save
  end
end
