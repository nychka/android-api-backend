class Gplus < SocialNetwork
  attr_accessor :user_fields, :endpoint

  def initialize(access_token, options = {})
    super(access_token, options)
    @user_fields = 'emails, ageRange, name(givenName, familyName), gender, image(url), url, placesLived, birthday'
    @photo_size = 200
  end
  def get_user_info
    get_data('/plus/v1/people/me',  { fields: user_fields }) do |body|
      if body.has_key? :emails
        body[:email] = body[:emails][0][:value] unless body[:emails].nil? && body[:emails].empty?
        body.delete(:emails)
      end
      if body.has_key? :name
        body[:first_name] = body[:name][:givenName] if body[:name][:givenName]
        body[:last_name] = body[:name][:familyName] if body[:name][:familyName]
        body.delete(:name)
      end
      if body.has_key? :ageRange
        body[:age] = body[:ageRange][:min] if body[:ageRange][:min]
        body.delete(:ageRange)
      end
      if body.has_key? :gender and not body[:gender].empty?
        body[:gender] = (body[:gender] == 'female') ? 1 : 2
      end
      if body.has_key? :image and not body[:image].empty?
        body[:photo] = body[:image][:url].gsub(/sz=\d+/, "sz=#{@photo_size}")
        body.delete(:image)
      end
      if body.has_key? :placesLived and not body[:placesLived].empty?
        places = body[:placesLived].find_all{|item| item if item[:primary] }
        body[:city] = places.first[:value] if places
        body.delete(:placesLived)
      end
      if body.has_key? :birthday
        date = Date._parse(body[:birthday])
        body[:bdate] = Date.parse(body[:birthday]).to_s if date.has_key?(:year) && date[:year] > 0
        body.delete(:birthday)
      end
      body
    end
  end
  def refresh_token!
    @endpoint = @endpoint.refresh!
    not @endpoint.expired?
  end
end