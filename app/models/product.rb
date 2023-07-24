class Product < ApplicationRecord
    belongs_to :user
    has_many_attached :images
    before_create :generate_serial_number

  private

  def generate_serial_number
    self.serial_number = generate_unique_serial_number
  end

  def generate_unique_serial_number
    loop do
      serial_number = SecureRandom.hex(4).upcase
      break serial_number unless Product.exists?(serial_number: serial_number)
    end
  end
end
