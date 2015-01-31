require 'rails_helper'

RSpec.describe "authentications/edit", :type => :view do
  before(:each) do
    @authentication = assign(:authentication, Authentication.create!(
      :user_id => 1,
      :provider => "MyString",
      :auth_token => "MyString",
      :refresh_token => "MyString"
    ))
  end

  it "renders the edit authentication form" do
    render

    assert_select "form[action=?][method=?]", authentication_path(@authentication), "post" do

      assert_select "input#authentication_user_id[name=?]", "authentication[user_id]"

      assert_select "input#authentication_provider[name=?]", "authentication[provider]"

      assert_select "input#authentication_auth_token[name=?]", "authentication[auth_token]"

      assert_select "input#authentication_refresh_token[name=?]", "authentication[refresh_token]"
    end
  end
end
