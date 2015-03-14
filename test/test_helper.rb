require 'simplecov'
if ENV['COVERAGE']
  SimpleCov.start do
    add_group "Models", "app/models"
    add_group "Controllers", "app/controllers"
    add_group "Social Networks", "app/social_networks"
  end
end

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'mocha/test_unit'
require 'database_cleaner'
require 'ostruct'

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
  DatabaseCleaner.strategy = :transaction

  def rabl_render(object, template, options = {})
    options = { view_path: 'app/views', format: :hash }.merge(options)
    if options[:current_user]
      options[:scope] = OpenStruct.new
      options[:scope].current_user = options[:current_user]
    end
    options.delete(:current_user)
    Rabl.render(object, template, options)
  end
end
class ActionController::TestCase
  include Devise::TestHelpers
end
