class User < ActiveRecord::Base
	has_many :authentications

  validates :first_name, presence: true, allow_blank: false
  validates :last_name,  presence: true, allow_blank: false
  validates :email,      presence: true, allow_blank: false
  validates :age,        presence: true, allow_blank: false
end
