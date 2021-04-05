# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    amount { 200 }
    quantity { 1 }
  end
end
