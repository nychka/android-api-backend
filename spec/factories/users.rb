FactoryGirl.define do
	factory :user do
		first_name 		{ Faker::Name.first_name }
		last_name 		{ Faker::Name.last_name }
		age 					{ rand(10..70) }
		email 				{ Faker::Internet.email }
		photo 				{ Faker::Avatar.image }
		access_token 	{ SecureRandom.urlsafe_base64(nil, false) }
		expires_at		{ DateTime.now + 1.day }
	end
	factory :social_user, class: User do
		first_name 		{ Faker::Name.first_name }
		last_name 		{ Faker::Name.last_name }
		age 					{ rand(10..70) }
		email 				{ Faker::Internet.email }
	end
end
