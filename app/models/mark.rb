class Mark < ActiveRecord::Base
  belongs_to :user
  belongs_to :marked_user, class: 'User'
end
