class PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user 
    if @post.save
      redirect_to post_path(@post)
    else
      puts @post.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  private
  def post_params
    params.require(:post).permit(:cafe_name, :body, :address, :cafe_link)
  end
end
