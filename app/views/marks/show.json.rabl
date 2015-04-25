object false
node(:status){ @status }
node :data do
  { 
    users: partial('users/guest_users', object: @users),
    # ads: partial('ads/ads', object: @ads)
  }
end