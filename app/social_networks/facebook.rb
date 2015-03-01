class Facebook < SocialNetwork
	attr_accessor :user_fields

	def initialize(access_token, options = {})
		super(access_token, options)
		@user_fields = 'first_name, last_name, email, age_range, gender, location, link, picture, birthday'
		@photo_size = { height: 200, width: 200 }
	end
	def get_picture(options={})
		options = @photo_size.merge(options)
		get_data('/me/picture', options.merge(redirect: false))
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
				response = get_picture
				if response[:success]
					body[:photo] = response[:body][:data][:url]
				else
					body[:photo] = body[:picture][:data][:url]
				end
				body.delete(:picture)
			end
			if body.has_key? :birthday
			 	bdate_format = '%m/%d/%Y'
        bdate = Date._strptime(body[:birthday], bdate_format)
        if bdate && bdate.has_key?(:year) && bdate[:year] > 0
        	body[:bdate] = Date.strptime(body[:birthday], bdate_format).to_s 
        end
        body.delete(:birthday)
      end
			body
		end
	end
end