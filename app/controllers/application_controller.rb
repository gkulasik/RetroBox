class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :check_session
  
  def check_session
    if cookies[:access_token] == nil || cookies[:refresh_token] == nil
      redirect_to main_authorize_path
    else
      establish_session
    end
  end
  
  def handle_expire
    redirect_to main_authorize_path
  end
  
  def save_tokens(access, refresh)
      cookies[:access_token] = { value: access.to_s, expires: 1.day.from_now }
      cookies[:refresh_token] = { value: refresh.to_s, expires: 1.day.from_now }
  end
  
  def establish_session
    token_refresh_callback = lambda {|access, refresh, identifier| save_tokens(access, refresh)}
    @client = Boxr::Client.new(cookies[:access_token], 
                          refresh_token: cookies[:refresh_token],
                          client_id: ENV['BOX_CLIENT_ID'],
                          client_secret: ENV['BOX_CLIENT_SECRET'],
                          &token_refresh_callback)
 
    begin
      @client.root_folder_items()
    rescue StandardError
      redirect_to main_authorize_path
    end
  end

end
