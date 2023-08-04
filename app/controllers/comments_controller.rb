class CommentsController < ApplicationController
  before_action :set_product, only: [:index, :destroy, :new, :create, :edit, :update]
  before_action :set_comment, only: [:destroy, :edit, :update]

  def index
    @comments = @product.comments.order(created_at: :desc)
  end

  def destroy
    redirect_to_index_if_not_comment_owner
    @comment.destroy
    redirect_to_index
  end

  def new
    redirect_to_index_if_product_owner
    @comment = @product.comments.build
  end

  def create
    redirect_to_index_if_product_owner
    @comment = @product.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to_index
    else
      flash[:errors] = @comment.errors.full_messages
      redirect_to_index
    end
  end

  def edit
    redirect_to_index_if_not_comment_owner
  end

  def update
    redirect_to_index_if_not_comment_owner
    if @comment.update(comment_params)
      redirect_to_index
    else
      flash[:errors] = @comment.errors.full_messages
      redirect_to_edit
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

  def current_user_is_owner?(obj_to_note)
    current_user.id == obj_to_note.user_id
  end

  def redirect_to_index
    redirect_to action: :index
  end

  def redirect_to_edit
    redirect_to action: :edit
  end

  def redirect_to_index_if_not_comment_owner
    redirect_to_index unless current_user_is_owner?(@comment)
  end

  def redirect_to_index_if_product_owner
    redirect_to_index if current_user_is_owner?(@product)
  end
end
