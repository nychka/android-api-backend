class Facebook < SocialNetwork
	attr_accessor :user_fields

	def initialize(access_token, options = {})
		super(access_token, options)
		@user_fields = 'first_name, last_name, email, age_range, gender, location, link, picture'
	end
	def get_user_info
		get_data('/me',  { fields: user_fields }) do |body|
			if body.has_key? :age_range and body[:age_range].has_key? :min
				body[:age] = body[:age_range][:min]
				body.delete(:age_range)
			end
			if body.has_key? :gender and not body[:gender].empty?
				body[:gender] = (body[:gender] == 'female') ? 1 : 2
			end
			if body.has_key? :location and not body[:location].empty?
				body[:city] = body[:location][:name].split(', ').first
				body.delete(:location)
			end
			if body.has_key? :link
				body[:url] = body[:link]
				body.delete(:link)
			end
			if body.has_key? :picture and not body[:picture].empty?
				body[:photo] = body[:picture][:data][:url]
				body.delete(:picture)
			end
			body
		end
	end
end