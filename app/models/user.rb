class User < ActiveRecord::Base
	has_many :authentications, dependent: :delete_all
  has_many :marks, dependent: :delete_all
  has_many :marked_users, through: :marks, class: Mark#, foreign_key: 'marked_user_id'

  validates :first_name, 		presence: true, allow_blank: false
  validates :last_name,  		presence: true, allow_blank: false
  validates :email,      		presence: true, allow_blank: false
  validates :age,        		presence: false, allow_blank: true
  validates :city,          presence: false, allow_blank: true
  validates :gender,        presence: false, allow_blank: true, inclusion: { in: 1..2 }
  validates :links,         presence: false, allow_blank: true
  validates :access_token, 	uniqueness: true

  after_create :generate_access_token!

  geocoded_by :city
  before_create    :geocode, :unless => lambda{ |user| user.city.blank? }
  after_validation :geocode, :if => lambda{ |user| user.persisted? and user.city_changed? }

  scope :nearby, ->(user){ self.near(user, Settings.radius_of_users).where("id != ?", user.id) }

  # OPTIMIZE: 
  def marked_users
    marked_user_ids = self.marks.pluck(:marked_user_id)
    User.find(marked_user_ids)
  end

  class << self
  	def authorize_by(params)
	  	if user = params[:access_token].present? ? User.find_by(params) : Authentication.find_by(params).try(:user)
	  		user.generate_access_token!
	  		user
	  	end
  	end
  end
  
  def add_social_network(params)
    auth = self.authentications.find_or_initialize_by(provider: params[:provider])
    auth.assign_attributes(auth_token: params[:auth_token])
    auth.save
  end
  

  def generate_access_token!
  	self.access_token = loop do
  		token = SecureRandom.urlsafe_base64(nil, false)
  		break token unless User.find_by(access_token: token)
  	end
  	self.expires_at	= DateTime.now + 1.day
  	self.save!
  end
end
