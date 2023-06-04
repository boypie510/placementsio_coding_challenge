# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HandleCurrencyConversionRate do
  let(:api_key) { 'fake_api_key' }
  let(:conversion_rates) { { 'USD' => 1.0, 'EUR' => 0.9, 'GBP' => 0.8 } }
  let(:cached_conversion_rates) { { 'USD' => 1.0, 'EUR' => 0.9 } }
  let(:currency) { 'EUR' }

  before do
    allow(ENV).to receive(:[]).with('EXCHANGE_RATE_API_KEY').and_return(api_key)
    allow(Rails.cache).to receive(:fetch).with('conversion_rates', expires_in: described_class::CACHE_EXPIRY).and_yield
    allow(subject).to receive(:fetch_conversion_rates_from_api).and_return(conversion_rates)
  end

  describe '#execute' do
    context 'when conversion rate is available in the cache' do
      before do
        allow(Rails.cache).to receive(:exist?).with('conversion_rates').and_return(true)
        allow(Rails.cache).to receive(:read).with('conversion_rates').and_return(cached_conversion_rates)
      end

      it 'returns the conversion rate for the specified currency' do
        expect(subject.execute(currency)).to eq(0.9)
      end
    end

    context 'when conversion rate is not available in the cache' do
      before do
        allow(Rails.cache).to receive(:exist?).with('conversion_rates').and_return(false)
      end

      it 'fetches conversion rates from the API and returns the conversion rate for the specified currency' do
        expect(subject.execute(currency)).to eq(0.9)
      end
    end

    context 'when the specified currency is not available in the conversion rates' do
      before do
        allow(Rails.cache).to receive(:exist?).with('conversion_rates').and_return(true)
        allow(Rails.cache).to receive(:read).with('conversion_rates').and_return(cached_conversion_rates)
      end

      it 'raises a ConversionRateUnavailableError' do
        expect { subject.execute('CAD') }.to raise_error(HandleCurrencyConversionRate::ConversionRateUnavailableError)
      end
    end
  end
end
