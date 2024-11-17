class UsersController < ApplicationController
  def following
    @user = User.find(params[:id])
    @following_users = @user.followings.includes(:profile)
  end

  def followers
    @user = User.find(params[:id])
    @followers_users = @user.followers
  end
end
