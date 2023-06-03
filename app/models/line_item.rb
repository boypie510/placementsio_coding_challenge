# frozen_string_literal: true

# record for booked_amount/actual_amount/adjusments
class LineItem < ApplicationRecord
  SORTABLE_COLUMNS = %w[name booked_amount actual_amount adjustments campaign_id].freeze
  SORTABLE_DIRECTION = %w[asc desc].freeze
  belongs_to :campaign

  validates :name, :booked_amount, :actual_amount, :adjustments, presence: true

  def self.invoice_grand_total
    sum('actual_amount + adjustments')
  end

  def billable_amount
    actual_amount + adjustments
  end
end
