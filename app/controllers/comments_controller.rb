class CommentsController < ApplicationController
  def new
    post = Post.find(params[:post_id])
    @comment = post.comments.build
  end

  def create
    post = Post.find(params[:post_id])
    @comment = post.comments.build(comment_params.merge(user: current_user)) # userを設定
    if @comment.save
      redirect_to post_path(post), notice: 'コメントを追加'
    else
      flash.now[:error] = 'コメントを追加できませんでした'
      render :new
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:content)
  end
end
