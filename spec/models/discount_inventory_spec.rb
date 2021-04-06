require 'rails_helper'

RSpec.describe DiscountInventory, type: :model do
  it { is_expected.to belong_to(:order) }
  it { is_expected.to belong_to(:discount) }
end
