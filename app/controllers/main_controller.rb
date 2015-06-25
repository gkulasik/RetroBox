class MainController < ApplicationController
skip_before_action :check_session


  def sign_out
    cookies[:access_token] = { value: nil }
    cookies[:refresh_token] = { value: nil }
    redirect_to main_authorize_path
  end

  def authorize
    
    if !params.has_key?("code")
      redirect_to Boxr::oauth_url(URI.encode_www_form_component("box_auth")).to_s   # doesnt matter what you put here.
    else
      @token = Boxr::get_tokens(params[:code])
      cookies[:access_token] = { value: @token.access_token.to_s, expires: 1.day.from_now }
      cookies[:refresh_token] = { value: @token.refresh_token.to_s, expires: 1.day.from_now }
      redirect_to content_index_path
    end
  end
end
