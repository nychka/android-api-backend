object @ad
attributes :price, :photo
node(:product_name){ |ad| ad.name }
node(:place){ |ad| ad.place.try(:name) }
node(:phone){ |ad| ad.place.try(:phone) }
node(:latitude){ |ad| ad.place.try(:latitude) }
node(:longitude){ |ad| ad.place.try(:longitude) }