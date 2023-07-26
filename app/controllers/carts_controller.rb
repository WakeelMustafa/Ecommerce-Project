class CartsController < ApplicationController

  def show
        @line_items = current_user.line_items
  end

end
