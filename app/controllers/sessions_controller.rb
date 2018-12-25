class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase

    if user && user.authenticate(params[:session][:password])
      if user.activated?
        login_success user
      else
        account_not_activated
      end
    else
      login_fail
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def account_not_activated
    message = t "check_email_to_active"
    flash[:warning] = message
    redirect_to root_url
  end

  def login_fail
    flash[:danger] = t "invalid_email_password"
    render :new
  end

  def login_success user
    log_in user
    remember_box_value = params[:session][:remember_me]
    remember_box_value == Settings.remember_me ? remember(user) : forget(user)
    redirect_back_or user
  end
end
