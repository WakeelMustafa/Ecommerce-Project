class CreateMyProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :my_products do |t|

      t.timestamps
    end
  end
end
