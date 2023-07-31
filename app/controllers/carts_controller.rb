class CartsController < ApplicationController

  def show
    if user_signed_in?
        @line_items = current_user.line_items.order(created_at: :desc)
    end
  end

  def apply_coupon
    @coupon = Coupon.find_by(code:params[:code])
    stripe_services = StripeServices.new
    current_user.line_items.each do |item|
      @product=Product.find(item.product_id)
      stripe_product=stripe_services.create_stripe_product(@product)
      stripe_product_price=stripe_services.create_stripe_product_price(stripe_product, @product, (@coupon.discount*10).to_i)
    end
  end

end
