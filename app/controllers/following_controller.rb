class FollowingController < ApplicationController
  before_action :logged_in_user
  
  def show
    @title = t "following"
    @user = User.find_by id: params[:id]
    @users = @user.following.page(params[:page])
                  .per Settings.micropost_items_per_page
    render "users/show_follow"
  end
end
