require 'rails_helper'

RSpec.describe Shop, type: :model do
  it { is_expected.to have_many(:order_items) }
  it { is_expected.to have_many(:products) }
end
