# frozen_string_literal: true

# record for booked_amount/actual_amount/adjusments
class LineItem < ApplicationRecord
  belongs_to :campaign

  validates :name, :booked_amount, :actual_amount, :adjustments, presence: true

  def billable_amount
    actual_amount + adjustments
  end
end
