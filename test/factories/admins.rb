FactoryGirl.define do
  factory :admin do
    email { Faker::Internet.email }
    password { SecureRandom.urlsafe_base64(8, true) }
  end
end
