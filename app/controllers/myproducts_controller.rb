class MyproductsController < ApplicationController

  def index
    @products = Product.order(created_at: :desc).paginate(page: params[:page], per_page: 8)
  end

  def show
    @product = Product.find(params[:id])
  end

end
