class ApplicationController < ActionController::Base
  before_action :merge_guest_line_items_with_user, if: :user_signed_in?
  protect_from_forgery with: :exception

  private

  def merge_guest_line_items_with_user
    if session[:guest_line_items].present?
      session[:guest_line_items].each do |product_id, quantity|
        product = Product.find(product_id)
        if current_user.id!= product.user_id
          @line_items=current_user.line_items.find_or_create_by(product: product).increment(:quantity, quantity)
          @line_items.save
        end
      end
      session.delete(:guest_line_items)
    end
  end

end
