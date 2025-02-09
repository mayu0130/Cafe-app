class TagsController < ApplicationController
  def show
    @tag = Tag.find(params[:id])
    @q = @tag.posts.ransack(params[:q])
    @posts = @q.result(distinct: true).order(created_at: :desc).page(params[:page]).per(8)
    @prefectures = Post::PREFECTURES
    @tags = Tag.all
  end
end
