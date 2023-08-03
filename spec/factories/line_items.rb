FactoryBot.define do
  factory :line_item do
    user
    product
    quantity { Faker::Number.between(from: 1, to: 10) }
  end
end
