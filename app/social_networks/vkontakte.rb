class Vkontakte < SocialNetwork
  attr_accessor :user_fields

  def initialize(access_token, options = {})
    super(access_token, options)
    @user_fields = 'sex,city,photo_200_orig,domain,bdate'
  end
  def get_user_info
    get_data('/method/users.get', uid: @options[:uid], fields: user_fields) do |body|
      raise "param :uid is not present, maybe you forgot to add it?" unless @options[:uid]

      if body[:response] and not body[:response].empty?
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
      if body.has_key? :photo_200_orig
        body[:photo] = body[:photo_200_orig]
        body.delete(:photo_200_orig)
      end
      if body.has_key? :city
        response = get_city_by_id(body[:city])
        if response[:success] and response[:body][:response].kind_of? Array
          body[:city] = response[:body][:response].first[:name] 
        else
          body.delete(:city)
        end
      end
      if body.has_key? :bdate
        date = Date._parse(body[:bdate])
        if date.has_key?(:year) && date[:year] > 0
          body[:bdate] = Date.parse(body[:bdate]).to_s 
        else
          body.delete(:bdate)
        end
      end
      body
    end
  end
  def get_city_by_id(id)
    get_data('/method/database.getCitiesById', city_ids: "#{id}")
  end
end