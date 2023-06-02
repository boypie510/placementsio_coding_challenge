# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'LineItems', type: :request do
  describe 'GET /index' do
    let(:invoice) { create(:invoice) }
    it 'renders the index template and returns a successful response' do
      get invoice_line_items_path(invoice)

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)
    end

    it "displays line items in a table/list" do
      # Create line items using FactoryBot
      line_item1 = create(:line_item, name: "Item 1", booked_amount: 100, actual_amount: 90, adjustments: 10)
      line_item2 = create(:line_item, name: "Item 2", booked_amount: 200, actual_amount: 180, adjustments: 20)

      # Make a GET request to the line items index
      get line_items_path

      # Write expectations to check if line items are displayed correctly in the table/list
      expect(response.body).to include(line_item1.name)
      expect(response.body).to include(line_item2.name)
    end
  end
end
