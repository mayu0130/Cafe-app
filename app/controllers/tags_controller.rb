class TagsController < ApplicationController
  def show
    @tag = Tag.find(params[:id])  # IDでタグを検索
    @posts = @tag.posts.page(params[:page]).per(8)
  end
end
