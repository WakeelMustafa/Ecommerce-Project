class Comment < ApplicationRecord
      belongs_to :product
      belongs_to :user
      validates :text, presence: true
      validates :text, length: { maximum: 25 }
end
