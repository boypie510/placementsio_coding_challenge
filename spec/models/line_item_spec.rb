# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LineItem, type: :model do
  let(:campaign) { create(:campaign) }

  describe '#billable_amount' do
    let(:line_item) { build(:line_item, actual_amount: 100, adjustments: 20) }

    it 'returns the sum of actual_amount and adjustments' do
      expect(line_item.billable_amount).to eq(120)
    end
  end

  describe '.sub_total' do
    let(:conversion_rate) { 0.75 }

    it 'calculates the sum of billable_amounts for a specific campaign' do
      line_item1 = create(:line_item, campaign: campaign, actual_amount: 100, adjustments: 20)
      line_item2 = create(:line_item, campaign: campaign, actual_amount: 150, adjustments: 30)
      expected_sub_total = (line_item1.billable_amount + line_item2.billable_amount) * conversion_rate

      sub_total = LineItem.sub_total(campaign.id, conversion_rate)

      expect(sub_total).to eq(expected_sub_total)
    end
  end
end
