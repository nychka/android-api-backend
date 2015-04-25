require 'test_helper'

class MarkTest < ActiveSupport::TestCase
  should belong_to(:user)
  should belong_to(:marked_user).class_name('User')
end
