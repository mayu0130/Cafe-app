class AccountsController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    @profile = @user.profile
    @posts = @user.posts.order(created_at: :desc).page(params[:page]).per(8)
    if @user == current_user
      redirect_to profile_path
    end
  end
end
