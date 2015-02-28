object false
node(:status){ @status }
node :data do
  { 
    user: partial('users/guest_user', object: @user),
    ads: partial('ads/ads', object: @ads)
  }
end