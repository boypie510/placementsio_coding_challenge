# frozen_string_literal: true

# Invoice line_items controller
class LineItemsController < ApplicationController
  before_action :find_campaign
  before_action :find_line_item
  before_action :check_reviewed_status, only: :update

  def update
    if @line_item.update(line_item_update_params)
      redirect_to campaign_path(@campaign), notice: 'Line item updated successfully.'
    else
      redirect_to campaign_path(@campaign), alert: 'Failed to update line item'
    end
  end

  def toggle_review
    @line_item.toggle!(:reviewed)
    redirect_to campaign_path(@campaign), notice: 'Line item review status updated successfully.'
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

  def check_reviewed_status
    return unless @line_item.reviewed?

    redirect_to campaign_path(@campaign), alert: 'Line item adjustments are disabled for reviewed items.'
  end
end
