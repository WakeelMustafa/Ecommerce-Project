class User < ApplicationRecord
  attr_accessor :firstname,:lastname
  has_many :products
  has_many :comments
  has_many :line_items
  has_one_attached:avatar
  validates :firstname, :lastname, presence: true
  before_create :concatenate_fullname

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  private

  def concatenate_fullname
    self.fullname = "#{firstname} #{lastname}".strip
  end

end
