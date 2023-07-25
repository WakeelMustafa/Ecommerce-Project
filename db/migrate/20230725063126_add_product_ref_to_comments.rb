class AddProductRefToComments < ActiveRecord::Migration[6.1]
  def change
    add_reference :comments, :product, null: false, foreign_key: true
  end
end
