class User < ActiveRecord::Base
	has_many :authentications

  validates :first_name, 		presence: true, allow_blank: false
  validates :last_name,  		presence: true, allow_blank: false
  validates :email,      		presence: true, allow_blank: false
  validates :age,        		presence: false, allow_blank: false
  validates :city,          presence: false, allow_blank: false
  validates :gender,        presence: false, allow_blank: false, inclusion: { in: 1..2 }
  validates :access_token, 	uniqueness: true

  after_create :generate_access_token!

  class << self
  	def authorize_by(params)
	  	if user = params[:access_token].present? ? User.find_by(params) : Authentication.find_by(params).try(:user)
	  		user.generate_access_token!
	  		user
	  	end
  	end
  end
  
  def add_social_network(params)
    self.authentications << Authentication.new(params)
  end
  

  def generate_access_token!
  	self.access_token = loop do
  		token = SecureRandom.urlsafe_base64(nil, false)
  		break token unless User.find_by(access_token: token)
  	end
  	self.expires_at	= DateTime.now + 1.day
  	self.save!
  end

  def as_json(options={})
    options = { except: [:created_at, :updated_at, :socials], methods: [:links, :bdate] }.merge(options)
    super(options)
  end

  def bdate
    birthday = read_attribute(:bdate)
    birthday.strftime('%d/%m/%Y') if birthday.kind_of? Date 
  end

  def links
    links = read_attribute(:socials)
    links.kind_of?(Hash) ? links.values : []
  end
end
