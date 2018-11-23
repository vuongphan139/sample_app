class UsersController < ApplicationController
  before_action :load_user
  before_action :logged_in_user, only: %i(index edit update destroy)
  before_action :correct_user, only: %i(edit update)

  def index
    @users = User.page(params[:page])
                 .per Settings.pagination.number_user_per_page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      log_in @user
      flash[:success] = t "welcome_sample_app"
      redirect_to @user
    else
      flash[:danger] = t "input_invalid"
      render :new
    end
  end

  def show; end

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
    User.find_by(id: params[:id]).destroy
    flash[:success] = t "user_deleted"
    redirect_to users_url
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "please_log_in"
    redirect_to login_url
  end

  def correct_user
    redirect_to root_url unless current_user?(@user)
  end

  private

  def user_params
    params.require(:user)
          .permit :name, :email, :password, :password_confirmation
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t "user_not_found"
    redirect_to root_url
  end
end
