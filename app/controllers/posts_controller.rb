class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  helper_method :prepare_meta_tags

  def index
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true).includes(:user).order(created_at: :desc)
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    @comments = @post.comments
    prepare_meta_tags(@post)
    @cafe_name = @post.cafe_name
  end

  def new
    @post = Post.new
    @tags = Tag.all
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    if @post.save
      redirect_to post_path(@post), notice: '投稿しました'
    else
      @tags = Tag.all
      flash.now[:error] = '投稿に失敗しました'
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @post = Post.find(params[:id])
    @tags = Tag.all
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path(@post), notice: '投稿を更新しました'
    else
      @tags = Tag.all
      flash.now[:error] = '更新に失敗しました'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    post = current_user.posts.find(params[:id])
    post.destroy!
    redirect_to posts_path , notice: '記事の投稿を削除しました'
  end

  def bookmarks
    @bookmark_posts = current_user.bookmarks.includes(:post).map(&:post)
  end

  def autocomplete
    if params[:query].present?
      @posts = Post.where('cafe_name LIKE ?', "%#{params[:query]}%").limit(10)
      render json: @posts.map(&:cafe_name)
    else
      render json: []
    end
  end

  private
  def post_params
    params.require(:post).permit(:cafe_name, :body, :address, :cafe_link, :image, :latitude, :longitude, tag_ids: [])
  end

  def prepare_meta_tags(post)
        image_url = "#{request.base_url}/images/ogp.png?text=#{CGI.escape(post.cafe_name)}"
        set_meta_tags og: {
                        site_name: 'Magco',
                        title: post.cafe_name,
                        description: 'ユーザーによるカフェの投稿です',
                        type: 'website',
                        url: request.original_url,
                        image: image_url,
                        locale: 'ja-JP'
                      },
                      twitter: {
                        card: 'summary_large_image',
                        site: 'https://x.com/m_0130k',
                        image: image_url
                      }
      end
end
