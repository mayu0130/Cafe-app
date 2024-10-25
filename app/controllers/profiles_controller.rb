class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @profile = current_user.profile
    @user = current_user
    @posts = @user.posts.order(created_at: :desc)
  end

  def edit
    @profile = current_user.prepare_profile
  end

  def update
    @profile = current_user.profile || current_user.build_profile
    @profile.assign_attributes(profile_params)

    # 画像が新しくアップロードされている場合のみ、avatar_imageを添付
    if params[:profile][:avatar].present?
      @profile.avatar.attach(params[:profile][:avatar])
    end

    if @profile.save
      redirect_to profile_path, notice: 'プロフィールを更新しました'
    else
      flash.now[:error] = '更新できませんでした'
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:nickname, :birthday, :mbti, :address, :introduction, :x_link, :instagram_link, :avatar)
  end
end
