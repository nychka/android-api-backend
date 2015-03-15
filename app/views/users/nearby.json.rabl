object false
node(:status){ @status }
node :data do
  { 
    users: partial('users/guest_users', object: @users)
  }
end