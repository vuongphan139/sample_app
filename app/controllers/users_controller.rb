class UsersController < ApplicationController
  before_action :load_user, only: %i(show edit update destroy)
  before_action :logged_in_user, only: %i(index edit update destroy)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @users = User.active.page(params[:page])
                 .per Settings.pagination.number_user_per_page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      @user.send_activation_email
      flash[:info] = t "check_email_to_active_account"
      redirect_to root_url
    else
      flash[:danger] = t "input_invalid"
      render :new
    end
  end

  def show
    return if @user.activated
    flash[:danger] = t "account_not_activated"
    redirect_to root_url
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "profile_updated"
      redirect_to @user
    else
      flash.now[:danger] = t "input_invalid"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "user_deleted"
    else
      flash[:danger] = t "user_deleted_failed"
    end
    redirect_to users_url
  end

  private

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "please_log_in"
    redirect_to login_url
  end

  def correct_user
    redirect_to root_url unless current_user?(@user)
  end

  def user_params
    params.require(:user)
          .permit :name, :email, :password, :password_confirmation
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t "user_not_found"
    redirect_to root_url
  end
end
