class ProductsController < ApplicationController
 before_action :set_product, only:[ :edit, :destroy, :update]
 before_action :authenticate_user!

  def index
    @products = current_user.products.order(created_at: :desc).paginate(page: params[:page], per_page: 8)
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
