FactoryGirl.define do
  factory :place do
    name      { Faker::Commerce.department }
    phone     { Faker::PhoneNumber.cell_phone }
    longitude { sprintf("%.6f", Faker::Address.longitude) }
    latitude  { sprintf("%.6f", Faker::Address.latitude) }
  end
  # 0.294 km away from facroty :geo_user
  factory :geo_place, class: Place, parent: :place do
    latitude 49.8395979
    longitude 24.051139
  end
end
