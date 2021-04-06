require 'rails_helper'

RSpec.describe Discount, type: :model do
  it { is_expected.to have_many(:discount_inventories) }
end
