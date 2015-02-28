class Place < ActiveRecord::Base
  validates :name,  presence: true, allow_blank: false
  validates :phone, presence: true, allow_blank: false

  has_many :ads
end
