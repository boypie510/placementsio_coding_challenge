# frozen_string_literal: true

# Adjustable Invoice, have line-items data
class Invoice < ApplicationRecord
  belongs_to :campaign
end
