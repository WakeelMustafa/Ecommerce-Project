class MyproductsController < ApplicationController

  def index
     if params[:search].present?
      @search_term = params[:search]
      @products = Product.search(@search_term)
    else
      @products = Product.order(created_at: :desc).paginate(page: params[:page], per_page: 8)
    end

  end

  def show
    @product = Product.find(params[:id])
  end

  def remove_cart_item
    current_user.line_items.destroy_all
    redirect_to(action: :index)
  end

end
