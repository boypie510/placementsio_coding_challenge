# frozen_string_literal: true

# Invoice line_items controller
class LineItemsController < ApplicationController
  before_action :find_line_item, only: [:update]

  def index
    @line_items = LineItem.includes(:campaign).page(params[:page]).per(25).order("#{sort_column} #{sort_direction}")
    @line_items_grouped_by_campaign = @line_items.group_by(&:campaign)

    campaign_ids = @line_items_grouped_by_campaign.keys.map(&:id)
    @subtotals_by_campaign = LineItem.subtotals_by_campaign(campaign_ids)

    @grand_total = LineItem.invoice_grand_total
  end

  def update
    if @line_item.update(line_item_update_params)
      redirect_to line_items_path, notice: 'Line item adjustments updated successfully.'
    else
      render :edit
    end
  end

  private

  def find_line_item
    @line_item = LineItem.find(params[:id])
  end

  def line_item_update_params
    params.require(:line_item).permit(:adjustments)
  end

  def sort_column
    LineItem::SORTABLE_COLUMNS.include?(params[:sort_by]) ? params[:sort_by] : 'name'
  end

  def sort_direction
    LineItem::SORTABLE_DIRECTION.include?(params[:sort_direction]) ? params[:sort_direction] : 'asc'
  end
end
