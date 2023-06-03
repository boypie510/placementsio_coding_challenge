# frozen_string_literal: true

# Invoice line_items controller
class LineItemsController < ApplicationController
  before_action :find_campaign, only: :update
  before_action :find_line_item, only: :update

  def update
    if @line_item.update(line_item_update_params)
      redirect_to campaign_path(@campaign), notice: 'Line item adjustments updated successfully.'
    else
      redirect_to campaign_path(@campaign), alert: 'Failed to update line item adjustments.'
    end
  end

  private

  def find_campaign
    @campaign = Campaign.find(params[:campaign_id])
  end

  def find_line_item
    @line_item = @campaign.line_items.find(params[:id])
  end

  def line_item_update_params
    params.require(:line_item).permit(:adjustments)
  end
end
