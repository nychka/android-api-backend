class Ad < ActiveRecord::Base
  validates :name,     presence: true, allow_blank: false
  validates :place_id, presence: true, allow_blank: false

  belongs_to :place

  scope :random, ->(limit = 1){ self.order("RANDOM()").limit(limit) }
end