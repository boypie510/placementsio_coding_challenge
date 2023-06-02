# frozen_string_literal: true

# Marketing campaign
class Campaign < ApplicationRecord
  has_one :invoice
  has_many :line_items

  validates :name, presence: true
end
