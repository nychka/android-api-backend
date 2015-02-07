FactoryGirl.define do
	factory :authentication do
		user
		provider 			{ %w{facebook gplus vkontakte}.sample }
		auth_token 		{ Digest::SHA1.hexdigest Time.now.to_s }
		refresh_token  "1509a3107c24047a3b69acc852c60ad8b90ac0d5"
	end

end
