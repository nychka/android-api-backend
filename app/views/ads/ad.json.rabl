object @ad
attributes :price, :photo
node(:product_name){ |ad| ad.name }
node(:place){ |ad| ad.place.name }
node(:phone){ |ad| ad.place.phone }
node(:latitude){ |ad| sprintf('%.6f', ad.place.lat) }
node(:longitude){ |ad| sprintf('%.6f', ad.place.lng) }