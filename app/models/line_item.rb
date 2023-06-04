# frozen_string_literal: true

# record for booked_amount/actual_amount/adjusments
class LineItem < ApplicationRecord
  SORTABLE_COLUMNS = %w[name booked_amount actual_amount adjustments campaign_id].freeze
  SORTABLE_DIRECTION = %w[asc desc].freeze
  belongs_to :campaign

  validates :name, :booked_amount, :actual_amount, :adjustments, presence: true

  def billable_amount
    actual_amount + adjustments
  end

  def self.sub_total(campaign_id, currency)
    conversion_rate = currency == 'USD' ? 1 : CurrencyConversionService.new.execute(currency)
    sum_of_billable_amounts = where(campaign_id: campaign_id).sum(&:billable_amount)
    sum_of_billable_amounts * conversion_rate
  end
end
