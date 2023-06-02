# frozen_string_literal: true

# create invoices table
class CreateInvoices < ActiveRecord::Migration[7.0]
  def change
    create_table :invoices do |t|
      t.references :campaign, foreign_key: true
      t.decimal :grand_total, precision: 24, scale: 14

      t.timestamps
    end
  end
end
