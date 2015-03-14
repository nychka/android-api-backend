object @user

attributes :id, :first_name, :last_name, :email, :photo, :city, :gender, :links, :age, :phone, :longitude, :latitude

glue(@user, :if => lambda{ |user| user == current_user }) do |user|
  attribute :access_token
end

node(:bdate) do |user|
  user.bdate.strftime('%d/%m/%Y') if user.bdate.kind_of?(Date)
end