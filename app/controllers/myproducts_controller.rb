class MyproductsController < ApplicationController

  def index
    @products = Product.order(created_at: :desc).paginate(page: params[:page], per_page: 8)
  end

  def show
    @product = Product.find(params[:id])
  end

  def remove_cart_item
    current_user.line_items.destroy_all
    redirect_to(action: :index)
  end

end
