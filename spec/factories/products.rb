FactoryBot.define do
  factory :product do
     user
    images {"sdtdstsfyfsyu"}
    name { Faker::Commerce.product_name }
    description { Faker::Lorem.paragraph }
    price { Faker::Commerce.price(range: 10.0..100.0) }
  end
end
