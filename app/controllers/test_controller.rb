class TestController < ApplicationController
  layout nil
  
  skip_before_filter :verify_authenticity_token
  skip_before_filter :authenticate_user!
  
  def login
    sign_in(User.find(params[:user_id]))
    render :text => 'ok'
  end
end if Rails.env.test?
