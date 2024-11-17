class TagsController < ApplicationController
  def show
    @tag = Tag.find(params[:id])  # IDでタグを検索
    @posts = @tag.posts # タグに関連するポストを取得 (ページネーションを使う場合)
  end
end
