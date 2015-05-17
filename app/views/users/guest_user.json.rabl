object @user

attributes :id, :first_name, :last_name, :email, :photo, :city, :gender, :links, :age, :bdate, :phone, :longitude, :latitude, :mac_address

node(:bdate) do |user|
  user.bdate.strftime('%d/%m/%Y') if user.bdate.kind_of?(Date)
end