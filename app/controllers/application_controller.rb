class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :check_session
  
  def check_session
    if cookies[:access_token] == nil || cookies[:refresh_token] == nil
      redirect_to main_authorize_path
    else
      establish_session
    end
  end
  
  def save_tokens(access, refresh)
      cookies[:access_token] = access.to_s
      cookies[:refresh_token] = refresh.to_s
  end
  
  def establish_session
    token_refresh_callback = lambda {|access, refresh, identifier| save_tokens(access, refresh)}
    @client ||= Boxr::Client.new(cookies[:access_token], 
                          refresh_token: cookies[:refresh_token],
                          client_id: ENV['BOX_CLIENT_ID'],
                          client_secret: ENV['BOX_CLIENT_SECRET'],
                          &token_refresh_callback)
  end

end
