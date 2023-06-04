# frozen_string_literal: true

# Filter campaigns
class CampaignFilter
  def initialize(campaigns)
    @campaigns = campaigns
  end

  def execute(filter_params)
    filtered_campaigns = @campaigns
    filtered_campaigns = filter_by_campaign_name(filtered_campaigns, filter_params[:campaign_name])
    filter_by_reviewed(filtered_campaigns, filter_params[:reviewed])
  end

  private

  def filter_by_campaign_name(campaigns, campaign_name)
    return campaigns unless campaign_name.present?

    campaigns.where('campaigns.name LIKE ?', "%#{Campaign.sanitize_sql_like(campaign_name)}%")
  end

  def filter_by_reviewed(campaigns, reviewed)
    return campaigns unless reviewed.present?

    campaigns.where(reviewed: reviewed)
  end
end
