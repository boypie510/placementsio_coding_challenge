# frozen_string_literal: true

require 'net/http'
require 'json'

# Service to get conversion rate compared to USD
class CurrencyConversionService
  API_KEY = ENV['EXCHANGE_RATE_API_KEY']
  API_ENDPOINT = "https://v6.exchangerate-api.com/v6/#{API_KEY}/latest/USD".freeze
  CACHE_EXPIRY = 1.hour

  class ConversionRateUnavailableError < StandardError; end

  def execute(currency)
    @conversion_rates = fetch_conversion_rates
    @conversion_rates[currency] || raise(ConversionRateUnavailableError)
  end

  private

  def fetch_conversion_rates
    if cached_conversion_rates_expired?
      conversion_rates = fetch_conversion_rates_from_api

      # Cache the conversion rates with expiry time
      Rails.cache.write('conversion_rates', conversion_rates, expires_in: CACHE_EXPIRY)
    else
      # Read conversion rates from cache
      conversion_rates = Rails.cache.read('conversion_rates')
    end

    conversion_rates
  end

  def cached_conversion_rates_expired?
    !Rails.cache.exist?('conversion_rates')
  end

  def fetch_conversion_rates_from_api
    uri = URI(API_ENDPOINT)
    response = Net::HTTP.get_response(uri)

    handle_conversion_rates_response(response)
  rescue StandardError => e
    Rails.logger.error("Error fetching conversion rates: #{e.message}")
    default_conversion_rates
  end

  def handle_conversion_rates_response(response)
    if response.is_a?(Net::HTTPSuccess)
      json_body = JSON.parse(response.body)
      json_body['conversion_rates']
    else
      handle_conversion_error(response)
    end
  end

  def handle_conversion_error(response)
    Rails.logger.error("API error: #{response.code} - #{response.message}")
    default_conversion_rates
  end

  def default_conversion_rates
    { 'USD' => 1.0 }
  end
end
