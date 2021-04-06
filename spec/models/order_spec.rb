# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order, type: :model do
  it { is_expected.to have_many(:order_items) }
  it { is_expected.to have_many(:discount_inventories) }

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
        it { is_expected.to be(20) }
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

      context 'when there is a rule: discount should not over $50' do
        let!(:discount) do
          create(:discount, scope: { all: { quantity: 2 } },
                       rules: { percent: 50, total_amount_check: 50 })
        end
        let(:quantity) { 2 }

        context 'when order discount is $20 before checking total amount' do
          let(:amount) { 80 }

          it { is_expected.to be(40) }
        end

        context 'when order discount is $100 before checking total amount' do
          let(:amount) { 200 }

          it { is_expected.to be(50) }
        end
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

    context 'when there is a discount: 10% off for product#1 for any order with 2 product#1' do
      let!(:discount) do
        create(:discount, scope: { product: { id: product1.id, quantity: 2 } },
          rules: { percent: { value: 10, product_id: product1.id} })
      end
      let(:product1) { create(:product, price: 100) }
      let(:product2) { create(:product, price: 150) }

      context 'when order include 2 product#2' do
        let!(:order_item) { create(:order_item, order: order, product: product2, quantity: 2) }

        it { is_expected.to be(0) }
      end

      context 'when order include 2 product#1' do
        let!(:order_item) { create(:order_item, order: order, product: product1, quantity: 2) }

        it { is_expected.to be(20) }
      end

      context 'when order include product#1 and product#2' do
        let!(:order_item1) { create(:order_item, order: order, product: product1, quantity: 2) }
        let!(:order_item2) { create(:order_item, order: order, product: product2, quantity: 2) }

        it { is_expected.to be(20) }
      end
    end

    context 'when there is a discount: $10 off for any order with 3 products in shop#1' do
      let!(:discount) do
        create(:discount, scope: { shop: { id: product1.shop.id, quantity: 2 } },
          rules: { amount: 10 })
      end
      let(:product1) { create(:product) }
      let(:product2) { create(:product, shop: product1.shop) }
      let(:product_from_other_shop) { create(:product) }

      context 'when order include 3 product in other shop' do
        let!(:order_item) { create(:order_item, order: order, product: product_from_other_shop, quantity: 3) }

        it { is_expected.to be(0) }
      end

      context 'when order include 1 product#1 and 2 product#2' do
        let!(:order_item1) { create(:order_item, order: order, product: product1, quantity: 1) }
        let!(:order_item2) { create(:order_item, order: order, product: product2, quantity: 2) }

        it { is_expected.to be(10) }
      end
    end

    context 'when there is a discount: 10% off for any order with 3 products in shop#1' do
      let!(:discount) do
        create(:discount, scope: { shop: { id: product1.shop.id, quantity: 2 } },
          rules: { percent: { value: 10, shop_id: product1.shop.id } })
      end
      let(:product1) { create(:product, price: 100) }
      let(:product2) { create(:product, shop: product1.shop, price: 100) }
      let(:product_from_other_shop) { create(:product) }

      context 'when order include 3 product in other shop' do
        let!(:order_item) { create(:order_item, order: order, product: product_from_other_shop, quantity: 3) }

        it { is_expected.to be(0) }
      end

      context 'when order include 1 product#1 and 2 product#2' do
        let!(:order_item1) { create(:order_item, order: order, product: product1, quantity: 1) }
        let!(:order_item2) { create(:order_item, order: order, product: product2, quantity: 2) }

        it { is_expected.to be(30) }
      end
    end

    context 'when there is a $10 off discount that can only be used for 1 times' do
      let!(:discount) do
        create(:discount, scope: { all: { times: 1 } },
          rules: { amount: 10 })
      end

      context 'when the discount is not used' do
        it { is_expected.to be(10) }
      end

      context 'when the discount is used 1 time' do
        let!(:order) do
          order = create(:order)
          order.calculate_discounts
          order
        end

        it { is_expected.to be(0) }
      end
    end

    context 'when there is a $10 off discount that can only be used for 1 times in a month' do
      let!(:discount) do
        create(:discount, scope: { all: { month_times: 1 } },
          rules: { amount: 10 })
      end

      context 'when the discount is not used' do
        it { is_expected.to be(10) }
      end

      context 'when the discount is used 1 time last month' do
        let!(:order) do
          order = create(:order, created_at: 1.month.ago)
          order.calculate_discounts
          order.discount_inventories.update_all(created_at: 1.month.ago)
          order
        end

        it { is_expected.to be(10) }
      end

      context 'when the discount is used 1 time' do
        let!(:order) do
          order = create(:order)
          order.calculate_discounts
          order
        end

        it { is_expected.to be(0) }
      end
    end
  end
end
