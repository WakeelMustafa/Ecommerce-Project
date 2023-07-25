class ProductsController < ApplicationController
 before_action :set_product, only:[:show, :edit, :destroy, :update]

  def index
    @products = current_user.products
  end

  def show; end

  def new
    @product = current_user.products.new
  end

  def create
    @product = current_user.products.new(product_params)
    @product.save
    redirect_to(action: :index)
  end

  def edit; end

  def update
    @product.update(product_params)
    redirect_to(action: :index)
  end

  def destroy
    @product.comments.destroy_all
    @product.destroy
    redirect_to(action: :index)
  end

  private

  def product_params
    params.require(:product).permit(:name, :description,:price,:serial_number, :images => [])
  end

  def set_product
    @product = current_user.products.find(params[:id])
  end
end
