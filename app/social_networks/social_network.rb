class SocialNetwork
  def initialize(access_token, options)
    @options = options
    @access_token = access_token
    klass = self.class.to_s.downcase
    @client = OAuth2::Client.new(Settings[klass]['app_id'], Settings[klass]['app_secret'], site: Settings[klass]['site'], token_url: Settings[klass]['token_url'])
    @endpoint = OAuth2::AccessToken.new(@client, access_token, { refresh_token: Settings[klass]['refresh_token'] })
  end
	def get_data(path, params)
    begin
      result = { success: true }
      response = @endpoint.get(path, params: params)
      result[:body] = JSON.parse(response.body).deep_symbolize_keys
      result[:body] = yield(result[:body]) if block_given?
      Rails.logger.debug(self.class.to_s){ result[:body] }
    rescue Exception => e
      Rails.logger.error(self.class.to_s) do
       "#{self.class.to_s} failed during fetching data from #{path} and was rescued by the following message: \n\n#{e.message} \n\n #{e.backtrace.join}"
      end
      result[:success] = false
      result[:error] = e.message
    ensure
      return result
    end
  end
end