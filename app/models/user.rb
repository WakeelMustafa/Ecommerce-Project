class User < ApplicationRecord
  has_many :products
  has_one_attached:avatar
  attribute :firstname
  attribute :lastname
  before_save :concatenate_fullname

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  private

  def concatenate_fullname
    self.fullname = "#{firstname} #{lastname}".strip
  end

end
