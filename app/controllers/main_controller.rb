class MainController < ApplicationController
skip_before_action :check_session


  def sign_out
    cookies[:access_token] = { value: nil }
    cookies[:refresh_token] = { value: nil }
    redirect_to main_authorize_path
  end

  def authorize
    if !params.has_key?("code")
      @session = RubyBox::Session.new({
                  client_id: ENV['BOX_CLIENT_ID'],
                  client_secret: ENV['BOX_CLIENT_SECRET']
                })
      redirect_to @session.authorize_url(ENV['BOX_REDIRECT_URI'])
    else
    @session = RubyBox::Session.new({
          client_id: ENV['BOX_CLIENT_ID'],
          client_secret: ENV['BOX_CLIENT_SECRET']
        })
    @token = @session.get_access_token(params[:code])

    @session = RubyBox::Session.new({
                  client_id: ENV['BOX_CLIENT_ID'],
                  client_secret: ENV['BOX_CLIENT_SECRET'],
                  access_token:  @token.token,
                })

      cookies[:access_token] = { value: @token.token.to_s, expires: 1.day.from_now }
      cookies[:refresh_token] = { value: @token.refresh_token.to_s, expires: 1.day.from_now }
      redirect_to content_index_path
    end
  end
end
