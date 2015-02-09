class Vkontakte < SocialNetwork
  attr_accessor :user_fields

  def initialize(access_token)
    super(access_token)
    @user_fields = 'sex,status'
  end
  def get_user_info
    get_data('/method/users.get', { uid: Settings.vkontakte.uid, fields: user_fields }) do |body|
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