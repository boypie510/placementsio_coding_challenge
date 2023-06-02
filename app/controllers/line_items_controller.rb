# frozen_string_literal: true

# Invoice line_items controller
class LineItemsController < ApplicationController
  before_action :find_line_item, only: [:update]

  def index
    @line_items = LineItem.page(params[:page]).per(25).order(:id)
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
end
