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
      decrement_line_item_quantity(@line_item)
    else
      decrement_guest_line_item_quantity(params[:id])
    end
    redirect_to carts_show_path, notice: 'Remove one more quantity'
  end

  def checkout
    stripe_lineitems = prepare_stripe_line_items
    stripe_session = StripeServices.new.create_checkout(stripe_lineitems)
    redirect_to stripe_session.url
  end

  def update
    if user_signed_in?
      @line_item = current_user.line_items.find(params[:id])
      increment_line_item_quantity(@line_item)
      redirect_to carts_show_path, notice: 'Add one more quantity'
    else
      increment_guest_line_item_quantity(params[:id])
      redirect_to carts_show_path, notice: 'Add one more quantity'
    end
  end

  private

  def create_line_item_for_user
    product = Product.find(params[:product_id])
    if current_user.id == product.user_id
      redirect_to myproducts_path, notice: 'You cannot add your own product to the cart.'
    else
      line_item = current_user.line_items.find_or_create_by(product: product)
      increment_line_item_quantity(line_item)
      redirect_to myproducts_path, notice: 'Product added to cart.'
    end
  end

  def create_line_item_for_guest
    product = Product.find(params[:product_id])
    session[:guest_line_items] ||= {}

    if session[:guest_line_items].key?(product.id.to_s)
      increment_guest_line_item_quantity(product.id.to_s)
    else
      session[:guest_line_items][product.id] = 1
    end

    redirect_to myproducts_path, notice: 'Product added to cart.'
  end

  def decrement_line_item_quantity(line_item)
    if line_item.quantity > 1
      line_item.decrement(:quantity)
      line_item.save
    else
      line_item.destroy
    end
  end

  def decrement_guest_line_item_quantity(product_id)
    session[:guest_line_items][product_id] -= 1 if session[:guest_line_items][product_id] > 0
    session[:guest_line_items].delete(product_id) if session[:guest_line_items][product_id] == 0
  end

  def increment_line_item_quantity(line_item)
    line_item.increment(:quantity)
    line_item.save
  end

  def increment_guest_line_item_quantity(product_id)
    session[:guest_line_items][product_id] += 1
  end

  def prepare_stripe_line_items
    stripe_lineitems = {}

    current_user.line_items.each do |item|
      product = Product.find(item.product_id)
      stripe_lineitems[product.stripe_product_price_id] = item.quantity
    end

    stripe_lineitems
  end
end
