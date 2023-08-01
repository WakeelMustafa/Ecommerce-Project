module ApplicationHelper

  def cart_total_quantity
    if user_signed_in?
      current_user.line_items.sum(:quantity)
    end
  end

end
