class GooglePlus < SocialNetwork
  attr_accessor :user_fields

  def initialize(access_token)
    super(access_token)
    @user_fields = 'emails, ageRange, name(givenName, familyName), gender'
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
      body
    end
  end
  def refresh_token!
    @endpoint = @endpoint.refresh!
    @endpoint.expired?
  end
end