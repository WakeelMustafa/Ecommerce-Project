class Product < ApplicationRecord
    has_many :comments, dependent: :destroy
    has_many :line_items, dependent: :destroy
    has_many_attached :images
    belongs_to :user
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
