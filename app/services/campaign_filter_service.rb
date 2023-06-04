# frozen_string_literal: true

# Filter campaigns
class CampaignFilterService
  def initialize(campaigns)
    @campaigns = campaigns
  end

  def execute(filter_params)
    filtered_campaigns = filter_campaigns(filter_params)
    filtered_grand_total = calculate_grand_total(filtered_campaigns)

    [filtered_campaigns, filtered_grand_total]
  end

  private

  def filter_campaigns(filter_params)
    filtered_campaigns = @campaigns
    filtered_campaigns = filter_by_campaign_name(filtered_campaigns, filter_params[:campaign_name])
    filter_by_reviewed(filtered_campaigns, filter_params[:reviewed])
  end

  def filter_by_campaign_name(campaigns, campaign_name)
    return campaigns unless campaign_name.present?

    campaigns.where('campaigns.name LIKE ?', "%#{campaign_name}%")
  end

  def filter_by_reviewed(campaigns, reviewed)
    return campaigns unless reviewed.present?

    campaigns.where(reviewed: reviewed)
  end

  def calculate_grand_total(campaigns)
    campaigns.joins(:line_items).sum('line_items.actual_amount + line_items.adjustments')
  end
end
