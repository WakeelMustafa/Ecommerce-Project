class LineItemsController < ApplicationController

  def create
    if user_signed_in?
      create_line_item_for_user
    else
      create_line_item_for_guest
    end
  end

  def destroy
    if user_signed_in?
      @line_item = current_user.line_items.find(params[:id])
      @line_item.update(quantity: @line_item.quantity-1) if @line_item.quantity > 0
      @line_item.destroy if @line_item.quantity == 0
      redirect_to carts_show_path, notice:  'Remove one more quantity'
    else
      session[:guest_line_items][params[:id]]-=1 if session[:guest_line_items][params[:id]]>0
      session[:guest_line_items].delete(params[:id]) if session[:guest_line_items][params[:id]]==0
      redirect_to carts_show_path, notice:  'Remove one more quantity'
    end
  end

  def checkout
    stripe_lineitems=Hash.new
    current_user.line_items.each do |item|
      product = Product.find(item.product_id)
      stripe_lineitems[product.stripe_product_price_id] = item.quantity
    end
    stripe_session=StripeServices.new.create_checkout(stripe_lineitems)
    redirect_to stripe_session.url

  end

  def update

    if user_signed_in?
      @line_item = current_user.line_items.find(params[:id])
      @line_item.update(quantity: @line_item.quantity+1)
      @line_item.save
      redirect_to carts_show_path, notice: 'Add one more quantity'
    else
      session[:guest_line_items][params[:id]]+=1
      redirect_to carts_show_path, notice: 'Add one more quantity'
    end

  end

private

  def create_line_item_for_user
    product = Product.find(params[:product_id])
    if current_user.id== product.user_id
      redirect_to myproducts_path, notice: 'You want add that Product to cart.'
    else
      @line_items=current_user.line_items.find_or_create_by(product: product).increment(:quantity)
      @line_items.save
      redirect_to myproducts_path, notice: 'Product added to cart.'
    end

  end

  def create_line_item_for_guest
    product = Product.find(params[:product_id])
    session[:guest_line_items] ||= {}
    unless session[:guest_line_items].has_key?(product.id.to_s)
     session[:guest_line_items][product.id] ||= 1
    else
     session[:guest_line_items][product.id.to_s]=  session[:guest_line_items][product.id.to_s] + 1
    end
    redirect_to myproducts_path, notice: 'Product added to cart.'
  end

end
