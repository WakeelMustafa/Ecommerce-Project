class CommentsController < ApplicationController
  before_action :set_product, only:[ :index, :destroy, :new, :create, :edit,  :update]
  before_action :set_comment, only:[ :destroy, :edit,  :update]

  def index
    @comments = @product.comments
  end

  def destroy
    if current_user.id != @comment.user_id
      redirect_to(action: :index)
    else
      @comment.destroy
      redirect_to(action: :index)
    end
  end

  def new
     @comment = @product.comments.build
     if current_user.id == @product.user_id
      redirect_to(action: :index)
    end
  end

  def create
     if current_user.id == @product.user_id
       redirect_to(action: :index)
     else
      @comment = @product.comments.build(comment_params)
      @comment.user = current_user
      @comment.save
      redirect_to(action: :index)
     end
  end

  def edit
    if current_user.id != @comment.user_id
      redirect_to(action: :index)
    end
  end

  def update
    if current_user.id != @comment.user_id
      redirect_to(action: :index)
    elsif current_user.id == @comment.user_id
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

  def set_product
    @product = Product.find(params[:product_id])
  end

  def set_comment
    @comment = @product.comments.find(params[:id])
  end

end
