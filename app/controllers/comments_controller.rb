class CommentsController < ApplicationController

  def index
    @product = Product.find(params[:product_id])
    @comments = @product.comments
  end

  def show
    @product = Product.find(params[:id])
    @comments = @product.comments
  end

   def destroy
    @product = Product.find(params[:product_id])
    @comment = @product.comments.find(params[:id])
    if current_user.email != @comment.product.user.email
      redirect_to(action: :index)
    else
    @comment.destroy
    redirect_to(action: :index)
    end
  end

  def new
    @product = Product.find(params[:product_id])
    @comment = @product.comments.build
    if current_user.id == @product.user_id
            redirect_to('/myproducts')
    end
  end

  def create
    @product = Product.find(params[:product_id])
      if current_user.id == @product.user_id
        redirect_to('/myproducts')
      else
      @comment = @product.comments.build
      @comment.save
      redirect_to(action: :index)
    end
  end

  def edit
     @product = Product.find(params[:product_id])
    @comment = @product.comments.find(params[:id])
    if current_user.email != @comment.product.user.email
      redirect_to(action: :index)
    end
  end

  def update
    @product = Product.find(params[:product_id])
    @comment = @product.comments.find(params[:id])
    if current_user.email != @comment.product.user.email
      redirect_to(action: :index)
    elsif current_user.email == @comment.product.user.email
    @comment.update(comment_params)
     redirect_to(action: :index)
    else
    redirect_to(action: :edit)
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:text)
  end

end
