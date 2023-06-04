# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CampaignFilter do
  describe '#execute' do
    subject { described_class.new(Campaign.all).execute(filter_params) }
    let(:campaign_example) { create(:campaign, name: 'example', reviewed: false) }
    let(:campaign_one) { create(:campaign, name: 'one', reviewed: false) }
    let(:campaign_reviewed) { create(:campaign, name: 'two', reviewed: true) }

    context 'when campaign name is provided' do
      let(:filter_params) { { campaign_name: 'example' } }

      it { is_expected.to eq([campaign_example]) }

      context 'when campaign_name/reviewed are provied' do
        let(:filter_params) { { campaign_name: 'example', reviewed: true } }

        it { is_expected.to eq([]) }
      end
    end

    context 'when campaign name is not provided, filters campaigns by reviewed only' do
      let(:filter_params) { { campaign_name: nil, reviewed: true } }

      it { is_expected.to eq([campaign_reviewed]) }
    end
  end
end
