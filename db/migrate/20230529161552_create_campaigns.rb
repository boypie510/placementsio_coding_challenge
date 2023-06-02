# frozen_string_literal: true

# create campaigns table
class CreateCampaigns < ActiveRecord::Migration[7.0]
  def change
    create_table :campaigns do |t|
      t.string :name, unique: true
      t.boolean :reviewed, null: false, default: false

      t.timestamps
    end
  end
end
