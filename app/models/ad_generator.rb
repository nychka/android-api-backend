class AdGenerator
  class << self
    def generate options = {}
      settings = { limit: Settings.ads_limit }.merge(options)

      places = Place.within_radius(settings[:current_user]) if settings[:current_user]
      
      if places and not places.empty?
        places.sample.ads.sample(settings[:limit])
      else
        Ad.random(settings[:limit])
      end
    end
  end
end