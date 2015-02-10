class Vkontakte < SocialNetwork
  attr_accessor :user_fields

  def initialize(access_token, options = {})
    super(access_token, options)
    @user_fields = 'sex,city'
  end
  def get_user_info
    get_data('/method/users.get', uid: @options[:uid], fields: user_fields) do |body|
      if body[:response] and body[:response].kind_of? Array
        body = body[:response].first
      end
      if body.has_key? :sex
        body[:gender] = (body[:sex] == 1) ? 'female' : 'male'
      end
      body
    end
  end
end