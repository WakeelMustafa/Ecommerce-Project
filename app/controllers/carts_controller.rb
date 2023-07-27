class CartsController < ApplicationController

  def show
    if user_signed_in?
        @line_items = current_user.line_items.order(created_at: :desc)
    end
  end

end
