def oauth_consumer
  raise RuntimeError, "You must set TWITTER_KEY and TWITTER_SECRET in your server environment." unless ENV['TWITTER_KEY'] and ENV['TWITTER_SECRET']
  @consumer ||= OAuth::Consumer.new(
    ENV['TWITTER_KEY'],
    ENV['TWITTER_SECRET'],
    :site => "https://api.twitter.com"
  )
end

def request_token
  if not session[:request_token]
    # this 'host_and_port' logic allows our app to work both locally and on Heroku
    host_and_port = request.host
    host_and_port << ":9393" if request.host == "localhost"

    # the `oauth_consumer` method is defined above
    session[:request_token] = oauth_consumer.get_request_token(
      :oauth_callback => "http://#{host_and_port}/auth"
    )
  end
  session[:request_token]
end


helpers do

  def current_user
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])
    end
  end

  # def twitter_client
  #   if session[:user_id]
  #     @twitter_user ||= Twitter::Client.new(
  #       oauth_token: current_user.oauth_token,
  #       oauth_token_secret: current_user.oauth_secret
  #     )
  #   end
  # end

  def logged_in?
    !current_user.nil?
  end

end

