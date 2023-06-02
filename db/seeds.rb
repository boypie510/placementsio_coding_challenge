# frozen_string_literal: true

require 'json'

# Read the JSON file
file_path = Rails.root.join('db', 'placements_teaser_data.json')
json_data = File.read(file_path)

# Parse the JSON data
data = JSON.parse(json_data)

# Import data into the line_item and campaign tables

ActiveRecord::Base.transaction do
  data.each do |item|
    campaign = Campaign.find_or_create_by(name: item['campaign_name'])
    invoice = campaign.invoice || campaign.create_invoice!

    campaign.line_items.create!(
      {
        invoice: invoice,
        name: item['line_item_name'],
        booked_amount: item['booked_amount'],
        actual_amount: item['actual_amount'],
        adjustments: item['adjustments']
      }
    )
  end
end

puts 'Data imported successfully!'
