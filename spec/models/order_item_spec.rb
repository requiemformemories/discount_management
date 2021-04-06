require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  it { is_expected.to belong_to(:order) }
  it { is_expected.to belong_to(:product) }
  it { is_expected.to belong_to(:shop) }

  describe 'update order after saved' do
    subject(:order) { create(:order, quantity: 0, amount: 0) }

    let!(:order_item){ create(:order_item, quantity: 3, amount: 300, order: order) }

    it { expect(order.quantity).to eq(3) }
    it { expect(order.amount).to eq(300) }
  end
end
