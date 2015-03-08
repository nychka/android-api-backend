require 'simplecov'
SimpleCov.start do
  add_group "Models", "app/models"
  add_group "Controllers", "app/controllers"
  add_group "Social Networks", "app/social_networks"
end

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'mocha/test_unit'
require 'database_cleaner'

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
  DatabaseCleaner.strategy = :transaction
end
class ActionController::TestCase
  include Devise::TestHelpers
end
