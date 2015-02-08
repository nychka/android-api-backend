class Facebook < SocialNetwork
	attr_accessor :user_fields

	def initialize(access_token)
		super(access_token)
		@user_fields = 'first_name, last_name, email, age_range'
	end
	def get_user_info
		get_data('/me',  { fields: user_fields }) do |body|
			if body.has_key? :age_range and body[:age_range].has_key? :min
				body[:age] = body[:age_range][:min]
				body.delete(:age_range)
			end
			body
		end
	end
end