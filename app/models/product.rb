class Product < ApplicationRecord
  belongs_to :shop
  has_many :order_items, dependent: :nullify
end
