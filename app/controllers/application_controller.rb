class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user

  before_filter :session_expiry, :except => [:login, :logout]
  before_filter :update_activity_time, :except => [:login, :logout]

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def session_expiry

    if current_user != nil then

    @time_left = (session[:expires_at] - Time.now).to_i
      unless @time_left > 0
        id = session[:user_id]
        old_user = User.find(id)
        if old_user.notAnonymus == nil then
          puts "entrou"
          histories = old_user.histories
          old_user.destroy
          histories.each do |h|
            h.destroy
          end
        end
        reset_session
      end
    end
  end

  def update_activity_time
    session[:expires_at] = 30.minutes.from_now
  end


end
