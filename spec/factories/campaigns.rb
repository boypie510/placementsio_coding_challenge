# frozen_string_literal: true

FactoryBot.define do
  factory :campaign do
    name { 'Example Campaign' }
    reviewed { false }
  end
end
