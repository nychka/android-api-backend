object false
node(:status){ @status }
node :data do
  { 
    marked_user: partial('users/guest_user', object: @user),
  }
end