require 'rails_helper'

RSpec.describe "authentications/show", :type => :view do
  before(:each) do
    @authentication = assign(:authentication, Authentication.create!(
      :user_id => 1,
      :provider => "Provider",
      :auth_token => "Auth Token",
      :refresh_token => "Refresh Token"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Provider/)
    expect(rendered).to match(/Auth Token/)
    expect(rendered).to match(/Refresh Token/)
  end
end
