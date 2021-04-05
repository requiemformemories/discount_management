# frozen_string_literal: true

FactoryBot.define do
  factory :discount do
    scope { { all: { amount: 100 } } }
    rules { { amount: 20 } }
  end
end
