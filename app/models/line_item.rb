# frozen_string_literal: true

# record for booked_amount/actual_amount/adjusments
class LineItem < ApplicationRecord
  belongs_to :campaign

  validates :name, :booked_amount, :actual_amount, :adjustments, presence: true

  def self.subtotals_by_campaign(campaign_ids)
    where(campaign_id: campaign_ids)
      .group(:campaign_id)
      .sum('actual_amount + adjustments')
  end

  def self.invoice_grand_total
    sum('actual_amount + adjustments')
  end

  def billable_amount
    actual_amount + adjustments
  end
end
