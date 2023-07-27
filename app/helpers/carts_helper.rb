module CartsHelper

  def total_price
    total_price = 0
    session[:guest_line_items]&.each do |product_id, quantity|
      product = Product.find(product_id)
      total_price += product.price * quantity
    end
    total_price
  end

end
