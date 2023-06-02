# frozen_string_literal: true

# Invoice line_items controller
class LineItemsController < ApplicationController
  def index
    @line_items = LineItem.page(params[:page]).per(25)
  end
end
