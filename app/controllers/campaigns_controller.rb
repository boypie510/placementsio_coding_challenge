class CampaignsController < ApplicationController

  def export_invoice
    @campaign = Campaign.find(params[:id])
    @line_items = @campaign.line_items

    respond_to do |format|
      format.csv { send_invoice_csv }
      format.xlsx { send_invoice_xlsx }
    end
  end

  private

  def send_invoice_csv
    file_name = "campaign_invoice_export_#{Time.zone.today.strftime('%Y%m%d')}.csv"
    csv_data = generate_invoice_csv
    send_data csv_data, filename: file_name, type: Mime[:csv].to_s, disposition: 'attachment'
  end

  def generate_invoice_csv
    CSV.generate do |csv|
      csv << ['Name', 'Booked Amount', 'Actual Amount', 'Adjustments', 'Billable Amount']

      @line_items.each do |line_item|
        csv << [line_item.name, line_item.booked_amount, line_item.actual_amount, line_item.adjustments, line_item.billable_amount]
      end
    end
  end

  def send_invoice_xlsx
    file_name = "campaign_invoice_export_#{Time.zone.today.strftime('%Y%m%d')}.xlsx"
    workbook = generate_invoice_xlsx
    file_path = Rails.root.join('tmp', file_name)

    workbook.write(file_path)

    send_file file_path, filename: file_name, disposition: 'attachment'
  end

  def generate_invoice_xlsx
    workbook = Spreadsheet::Workbook.new
    worksheet = workbook.create_worksheet(name: @campaign.name)

    worksheet.row(0).concat(['Name', 'Booked Amount', 'Actual Amount', 'Adjustments', 'Billable Amount'])

    @line_items.each_with_index do |line_item, index|
      worksheet.row(index + 1).concat([line_item.name, line_item.booked_amount, line_item.actual_amount, line_item.adjustments, line_item.billable_amount])
    end

    workbook
  end
end
