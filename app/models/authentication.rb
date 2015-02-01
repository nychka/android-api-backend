class Authentication < ActiveRecord::Base
	belongs_to :user

  validates :user_id,    presence: true, allow_blank: false
  validates :provider,   presence: true, allow_blank: false
  validates :auth_token, presence: true, allow_blank: false, uniqueness: { 
    scope: :provider, message: 'must be unique in provider scope', case_sensitive: false
  }
end
