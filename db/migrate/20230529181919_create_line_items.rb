# frozen_string_literal: true

# create line_items table
class CreateLineItems < ActiveRecord::Migration[7.0]
  def change
    create_table :line_items do |t|
      t.references :campaign, foreign_key: true
      t.string :name
      t.decimal :booked_amount, precision: 24, scale: 14
      t.decimal :actual_amount, precision: 24, scale: 14
      t.decimal :adjustments, precision: 24, scale: 14
      t.boolean :reviewed, null: false, default: false

      t.timestamps
    end
  end
end
