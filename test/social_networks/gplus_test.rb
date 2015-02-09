require 'test_helper'

class GplusTest < ActiveSupport::TestCase
  def setup
    @provider = Gplus.new(Settings.gplus.access_token)
    @url = '/plus/v1/people/me'
  end
  test "#get_data" do
    response = @provider.get_data(@url, { fields: 'gender,ageRange,emails, name(familyName,givenName)' })
    assert response[:success]
    assert_equal 'male', response[:body][:gender]
    assert_equal 'nychka93@gmail.com',   response[:body][:emails][0][:value]
    assert_equal 'Ярослав', response[:body][:name][:givenName]
    assert_equal 'Ничка', response[:body][:name][:familyName]
    assert_equal 21, response[:body][:ageRange][:min]
  end
  test "#get_data with invalid token" do
    provider = Gplus.new('invalid_token')
    response = provider.get_data(@url, { fields: 'gender' })
    refute response[:success]
    assert_match /Invalid Credentials/, response[:error]
  end
  test "#get_data with invalid field" do
    response = @provider.get_data(@url, { fields: 'gender,ageRange,emails,familyName' })
    refute response[:success]
    assert_match /Invalid field selection familyName/, response[:error]
  end
  test "#get_user_info" do
    response = @provider.get_user_info
    assert response[:success]
    assert_equal 'male', response[:body][:gender]
    assert_equal 'nychka93@gmail.com',   response[:body][:email]
    assert_equal 'Ярослав', response[:body][:first_name]
    assert_equal 'Ничка', response[:body][:last_name]
    assert_equal 21, response[:body][:age]
  end
  test "refresh token" do
    provider = Gplus.new('invalid_token')
    response = provider.get_user_info
    refute response[:success]
    assert_match /Invalid Credentials/, response[:error]
    provider.refresh_token!
    response = provider.get_user_info
    assert_equal 'male', response[:body][:gender]
    assert_equal 'nychka93@gmail.com',   response[:body][:email]
    assert_equal 'Ярослав', response[:body][:first_name]
    assert_equal 'Ничка', response[:body][:last_name]
    assert_equal 21, response[:body][:age]
  end
end