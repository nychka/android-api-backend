require 'rails_helper'

describe AuthController, :type => :controller do
	context "registration" do

		subject(:auth_token){ Digest::SHA1.hexdigest Time.now.to_s }

		it "GET /auth" do
			get :create, { format: :json }
			expect(response.status).to eq 200
		end
		it "temporary creates user", focus: true do
			get :create, { provider: 'facebook', auth_token: auth_token, format: :json }
			expect(response.status).to eq 200
			body = JSON.parse(response.body).symbolize_keys!
			p body
			auth = Authentication.find_by(provider: 'facebook', auth_token: auth_token)
			expect(auth).not_to be nil
			expect(auth.auth_token).to eq auth_token
			expect(body[:code]).to eq 101
		end
	end
	context "authorization" do
	end
end
