# frozen_string_literal: true

# line_item views helper
module LineItemsHelper
  def sortable_column_link(column_name, attribute)
    link_to column_name, { sort_by: attribute, sort_direction: direction(attribute) }
  end

  private

  def direction(attribute)
    # if sort direction already asc, turn into desc
    if attribute == params[:sort_by] && params[:sort_direction] == 'asc'
      'desc'
    else
      'asc'
    end
  end
end
