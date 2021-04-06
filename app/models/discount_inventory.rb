class DiscountInventory < ApplicationRecord
  belongs_to :discount
  belongs_to :order
end
