# frozen_string_literal: true

# Campaign controller
class CampaignsController < ApplicationController
  before_action :find_campaign, only: %i[show export_invoice]
  CAMPAIGN_PER_PAGE = 25
  LINE_ITEM_PER_PAGE = 25

  def index
    campaign_filter = CampaignFilter.new(Campaign.all)
    filtered_campaigns = campaign_filter.execute(filter_params)

    @campaigns = filtered_campaigns.page(params[:page]).per(CAMPAIGN_PER_PAGE)
    @grand_total = filtered_campaigns.joins(:line_items).sum('line_items.actual_amount + line_items.adjustments')
  end

  def show
    @line_items =
      @campaign.line_items.includes(:campaign).page(params[:page]).per(LINE_ITEM_PER_PAGE).order(sort_column => sort_direction)
    @selected_currency = params[:currency] || 'USD'

    handle_conversion_rate_exception do
      @sub_total = LineItem.sub_total(@campaign.id, @selected_currency)
    end
  end

  def export_invoice
    @line_items = @campaign.line_items
    invoice_generator = InvoiceGenerator.new(@line_items)

    respond_to do |format|
      format.csv { send_invoice_file(invoice_generator, :csv) }
      format.xlsx { send_invoice_file(invoice_generator, :xlsx) }
    end
  rescue ArgumentError => e
    redirect_to campaigns_path, alert: e.message
  end

  private

  def find_campaign
    @campaign = Campaign.find(params[:id])
  end

  def send_invoice_file(generator, type)
    generator.execute(type) do |data, filename, content_type|
      send_tempfile(data, filename, content_type)
    end
  end

  def send_tempfile(data, file_name, content_type)
    send_data data, filename: file_name, type: content_type, disposition: 'attachment'
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
