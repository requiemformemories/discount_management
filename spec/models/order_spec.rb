# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order, type: :model do
  it { is_expected.to have_many(:order_items) }

  subject(:order) { create(:order, amount: amount, created_at: created_at, quantity: quantity) }
  let(:amount) { 200 }
  let(:quantity) { 1 }
  let(:created_at) { Time.now }

  describe '#calculate_discounts' do
    subject { order.calculate_discounts }
    context 'when there is a discount: $20 off for any order over $200' do
      let!(:discount) do
        create(:discount, scope: { all: { amount: 200 } },
                     rules: { amount: 20 })
      end

      context 'when order amount is $190' do
        let(:amount) { 190 }
        it { is_expected.to be(0) }
      end

      context 'when order amount is $200' do
        it { is_expected.to be(20) }
      end
    end

    context 'when there is a discount: 10% off for any order over $200' do
      let!(:discount) do
        create(:discount, scope: { all: { amount: 200 } },
                     rules: { percent: 10 })
      end

      context 'when order amount is $190' do
        let(:amount) { 190 }
        it { is_expected.to be(0) }
      end

      context 'when order amount is $200' do
        it { is_expected.to be(20.0) }
      end
    end

    context 'when there is a discount: $20 off for any order with two order items' do
      let!(:discount) do
        create(:discount, scope: { all: { quantity: 2 } },
                     rules: { amount: 20 })
      end

      context 'when order quantity is 1' do
        it { is_expected.to be(0) }
      end

      context 'when order quantity is 2' do
        let(:quantity) { 2 }
        it { is_expected.to be(20) }
      end
    end

    context 'when there is a discount: $10 off for any order on January 2021' do
      let!(:discount) do
        create(:discount, scope: { all: { start_at: Time.new(2021, 1, 1), end_at: Time.new(2021, 1, 31) } },
                     rules: { amount: 10 })
      end

      context 'when order is created at 2020-12-31' do
        let(:created_at) { Time.new(2020, 12, 31) }
        it { is_expected.to be(0) }
      end

      context 'when order is created at 2021-02-01' do
        let(:created_at) { Time.new(2021, 2, 1) }
        it { is_expected.to be(0) }
      end

      context 'when order is created at 2021-01-15' do
        let(:created_at) { Time.new(2021, 1, 15) }
        it { is_expected.to be(10) }
      end
    end

    context 'when there is a discount: $10 off for any order with 2 product#1' do
      let!(:discount) do
        create(:discount, scope: { product: { id: product1.id, quantity: 2 } },
          rules: { amount: 10 })
      end
      let(:product1) { create(:product) }
      let(:product2) { create(:product) }

      context 'when order include 2 product#2' do
        let!(:order_item) { create(:order_item, order: order, product: product2, quantity: 2) }

        it { is_expected.to be(0) }
      end

      context 'when order include 2 product#1' do
        let!(:order_item) { create(:order_item, order: order, product: product1, quantity: 2) }

        it { is_expected.to be(10) }
      end
    end
  end
end
