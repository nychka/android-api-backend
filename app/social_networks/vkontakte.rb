class Vkontakte < SocialNetwork
  attr_accessor :user_fields

  def initialize(access_token, options = {})
    super(access_token, options)
    @user_fields = 'sex,city,photo_100,domain'
  end
  def get_user_info
    get_data('/method/users.get', uid: @options[:uid], fields: user_fields) do |body|
      if body[:response] and body[:response].kind_of? Array
        body = body[:response].first
      end
      if body.has_key? :sex
        body[:gender] = body[:sex]
        body.delete(:sex)
      end
      if body.has_key? :domain
        body[:url] = "#{Settings.vkontakte.base_site}/#{body[:domain]}"
        body.delete(:domain)
      end
      if body.has_key? :photo_100
        body[:photo] = body[:photo_100]
        body.delete(:photo_100)
      end
      body
    end
  end
  def get_user_city(id)
    # Your code goes here
  end
end