class AddSerialNumberToProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :serial_number, :string
  end
end
