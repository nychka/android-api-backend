FactoryGirl.define do
  factory :ad do
    name { Faker::Commerce.product_name }
    price { Faker::Commerce.price.to_s }
    place
    photo { Faker::Avatar.image }
  end
end
