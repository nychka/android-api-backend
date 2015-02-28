object false
node(:status){ @status }
node :data do
  { 
    user: partial('users/user', object: @user),
  }
end