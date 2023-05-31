# frozen_string_literal: true

# Adjustment Invoice Controller
class InvoicesController < ApplicationController
  def index
    @invoices = Invoice.all
  end
end
