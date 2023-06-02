# frozen_string_literal: true

FactoryBot.define do
  factory :invoice do
    name { 'Example Line Item' }
    booked_amount { 100 }
    actual_amount { 90 }
    adjustments { 10 }
  end
end
