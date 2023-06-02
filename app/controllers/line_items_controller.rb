# frozen_string_literal: true

# Invoice line_items controller
class LineItemsController < ApplicationController
  def index
    @line_items = invoice.line_items.page(params[:page]).per(25)
  end

  private

  def invoice
    @invoice ||= Invoice.find(params[:invoice_id])
  end
end
