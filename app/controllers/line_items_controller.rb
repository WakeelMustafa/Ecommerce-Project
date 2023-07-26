class LineItemsController < ApplicationController

  def create
    product = Product.find(params[:product_id])
    if current_user.id== product.user_id
      redirect_to myproducts_path, notice: 'You want add that Product to cart.'
    else
    @line_items=current_user.line_items.find_or_create_by(product: product).increment(:quantity)
    @line_items.save
    redirect_to myproducts_path, notice: 'Product added to cart.'
    end
  end

  def destroy
    @line_item = current_user.line_items.find(params[:id])
    @line_item.update(quantity: @line_item.quantity-1) if @line_item.quantity > 1
    @line_item.destroy if @line_item.quantity == 1
    redirect_to carts_show_path, notice:  'Remove one more quantity'
  end

  def update
    @line_item = current_user.line_items.find(params[:id])
    @line_item.update(quantity: @line_item.quantity+1)
    @line_item.save
    redirect_to carts_show_path, notice: 'Add one more quantity'
  end

end
