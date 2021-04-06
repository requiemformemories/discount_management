class OrderItem < ApplicationRecord
  belongs_to :shop
  belongs_to :product
  belongs_to :order

  before_validation :update_info
  after_create :update_order

  validates_presence_of :quantity

  def update_info
    return unless product && quantity

    self.shop_id = product.shop_id
    self.amount ||= quantity * product.price
  end

  def update_order
    order.amount += amount
    order.quantity += quantity
    order.save
  end
end
