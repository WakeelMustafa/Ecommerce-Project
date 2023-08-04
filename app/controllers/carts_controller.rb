class CartsController < ApplicationController
  def show
    @line_items = current_user.line_items.order(created_at: :desc) if user_signed_in?
  end

  def apply_coupon
    @coupon = Coupon.find_by(code: params[:code])
    stripe_services = StripeServices.new
    current_user.line_items.each do |item|
      product = Product.find(item.product_id)
      stripe_product = stripe_services.create_stripe_product(product)
      stripe_product_price = stripe_services.create_stripe_product_price(stripe_product, product, @coupon.discount)
    end
  end
end
