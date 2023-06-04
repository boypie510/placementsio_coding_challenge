# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InvoiceGenerator do
  let(:campaign) { create(:campaign) }
  let!(:line_item) { create(:line_item, name: 'line_item', campaign: campaign) }
  let!(:line_item2) { create(:line_item, name: 'line_item2', campaign: campaign) }
  let(:invoice_generator) { described_class.new(campaign.line_items) }

  describe '#execute' do
    context 'when type is :csv' do
      it 'generates a CSV invoice with correct data' do
        invoice_generator.execute(:csv) do |file_data, _, _|
          parsed_csv = CSV.parse(file_data)

          expect(parsed_csv.length).to eq(campaign.line_items.count + 1) # Header + 5 line items
          expect(parsed_csv[0]).to eq(['Name', 'Booked Amount', 'Actual Amount', 'Adjustments', 'Billable Amount'])
          expect(parsed_csv[1]).to eq(
            [
              line_item.name,
              line_item.booked_amount.to_f.to_s,
              line_item.actual_amount.to_f.to_s,
              line_item.adjustments.to_f.to_s,
              line_item.billable_amount.to_f.to_s
            ]
          )
        end
      end
    end

    context 'when type is :xlsx' do
      it 'generates an XLSX invoice with correct data' do
        invoice_generator.execute(:xlsx) do |file_data, _, _|
          workbook = Spreadsheet.open(StringIO.new(file_data))
          worksheet = workbook.worksheet(0)

          expect(worksheet.row(0)).to eq(['Name', 'Booked Amount', 'Actual Amount', 'Adjustments', 'Billable Amount'])
          campaign.line_items.each_with_index do |line_item, index|
            expect(worksheet.row(index + 1)).to eq([line_item.name, line_item.booked_amount, line_item.actual_amount, line_item.adjustments, line_item.billable_amount])
          end
        end
      end
    end

    context 'when type is invalid' do
      it 'raises an ArgumentError' do
        expect { invoice_generator.execute(:pdf) }.to raise_error(ArgumentError, 'Invalid file type: pdf')
      end
    end
  end
end
