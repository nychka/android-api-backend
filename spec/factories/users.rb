FactoryGirl.define do
	factory :user do
		first_name 	{ Faker::Name.first_name }
		last_name 	{ Faker::Name.last_name }
		age 				{ rand(10..70) }
		email 			{ Faker::Internet.email }
		photo 			{ Faker::Avatar.image }
	end

end
