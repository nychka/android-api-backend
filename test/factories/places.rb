FactoryGirl.define do
  factory :place do
    name      { Faker::Commerce.department }
    phone     { Faker::PhoneNumber.cell_phone }
    longitude { sprintf("%.6f", Faker::Address.longitude) }
    latitude  { sprintf("%.6f", Faker::Address.latitude) }
  end

end
