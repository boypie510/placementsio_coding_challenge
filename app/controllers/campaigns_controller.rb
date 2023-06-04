# frozen_string_literal: true

# Campaign controller
class CampaignsController < ApplicationController
  before_action :find_campaign, only: %i[show export_invoice]

  def index
    campaign_filter = CampaignFilterService.new(Campaign.all)
    filtered_campaigns, filtered_grand_total = campaign_filter.execute(filter_params)

    @campaigns = filtered_campaigns.page(params[:page]).per(25)
    @grand_total = filtered_grand_total
  end

  def show
    @line_items = @campaign.line_items.includes(:campaign).page(params[:page]).per(25).order("#{sort_column} #{sort_direction}")
    @selected_currency = params[:currency] || 'USD'

    handle_conversion_rate_exception do
      @sub_total = LineItem.sub_total(@campaign.id, @selected_currency)
    end
  end

  def export_invoice
    @line_items = @campaign.line_items

    respond_to do |format|
      format.csv { send_invoice_csv }
      format.xlsx { send_invoice_xlsx }
    end
  end

  private

  def find_campaign
    @campaign = Campaign.find(params[:id])
  end

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

  def sort_column
    LineItem::SORTABLE_COLUMNS.include?(params[:sort_by]) ? params[:sort_by] : 'name'
  end

  def sort_direction
    LineItem::SORTABLE_DIRECTION.include?(params[:sort_direction]) ? params[:sort_direction] : 'asc'
  end

  def filter_params
    params.permit(:campaign_name, :reviewed)
  end

  def handle_conversion_rate_exception
    yield
  rescue CurrencyConversionService::ConversionRateUnavailableError
    @selected_currency = 'USD'
    @sub_total = LineItem.sub_total(@campaign.id, @selected_currency)
    flash.now[:alert] = 'Failed to retrieve conversion rates. Using default currency (USD).'
  end
end
