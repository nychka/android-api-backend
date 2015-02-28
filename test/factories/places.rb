FactoryGirl.define do
  factory :place do
    name { Faker::Commerce.department }
    phone { Faker::PhoneNumber.cell_phone }
    lng { Faker::Address.longitude }
    lat { Faker::Address.latitude }
  end

end
