class Place < ActiveRecord::Base
  validates :name,  presence: true, allow_blank: false
  validates :phone, presence: true, allow_blank: false

  has_many :ads

  scope :with_ads, ->(){ self.joins(:ads).having('COUNT(ads.id) > 0').group('places.id') }
  scope :within_radius, ->(object, radius = Settings.radius_of_places){ self.with_ads.near(object, radius).reorder("places.name DESC") }

  geocoded_by :address
  after_validation :geocode, :if => :address_changed?
end
