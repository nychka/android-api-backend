FactoryGirl.define do
	factory :user do
		first_name 		{ Faker::Name.first_name }
		last_name 		{ Faker::Name.last_name }
		age 					{ rand(10..70) }
		email 				{ Faker::Internet.email }
		photo 				{ Faker::Avatar.image }
		gender 				{ [1, 2].sample }
		city					{ Faker::Address.city }
		access_token 	{ SecureRandom.urlsafe_base64(nil, false) }
		expires_at		{ DateTime.now + 1.day }
	end
	factory :social_user, class: User do
		first_name 		{ Faker::Name.first_name }
		last_name 		{ Faker::Name.last_name }
		age 					{ rand(10..70) }
		email 				{ Faker::Internet.email }
		gender 				{ [1, 2].sample }
		city					{ Faker::Address.city }
		url 					{ Faker::Internet.url }
		photo 				{ Faker::Avatar.image }
	end
	factory :model_user, class: User, parent: :user do
		links { Settings.social_networks.map{|item|  Faker::Internet.url } }
		bdate { 20.years.ago.to_date }
	end
	factory :geo_user, class: User, parent: :user do
		latitude  49.8385295
		longitude 24.0548934
		city      nil
	end
end
