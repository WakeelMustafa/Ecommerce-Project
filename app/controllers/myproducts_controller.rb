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
    stripe_services = StripeServices.new
    current_user.line_items.each do |item|
      @product=Product.find(item.product_id)
      stripe_product=stripe_services.create_stripe_product(@product)
      stripe_product_price=stripe_services.create_stripe_product_price(stripe_product, @product,1)
    end
    current_user.line_items.destroy_all
    redirect_to(action: :index)
  end

end
