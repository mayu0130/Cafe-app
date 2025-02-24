class CommentsController < ApplicationController
  before_action :authenticate_user!

  def new
    post = Post.find(params[:post_id])
    @comment = post.comments.build
  end

  def create
    post = Post.find(params[:post_id])
    @comment = post.comments.build(comment_params.merge(user: current_user))

    if @comment.save
      redirect_to post_path(post), notice: 'コメントを追加'
    else
      flash.now[:error] = 'コメントを追加できませんでした'
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
  end

  def update
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])

    if @comment.update(comment_params)
      redirect_to post_path(@post), notice: 'コメントを更新しました。'
    else
      flash.now[:error] = '更新できませんでした。'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    @comment.destroy
    flash[:notice] = 'コメントが削除されました。'
    redirect_to @post
  end

  private
  def comment_params
    params.require(:comment).permit(:content)
  end
end
