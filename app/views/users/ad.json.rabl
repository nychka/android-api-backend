object @ad
attributes :price, :photo
node(:product_name){ |ad| ad.name }
node(:place){ |ad| ad.place.name }
node(:phone){ |ad| ad.place.phone }