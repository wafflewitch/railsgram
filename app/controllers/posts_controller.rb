class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = Post.of_followed_users(current_user.following).with_attached_image.order(created_at: :desc)
  end

  def explore
    @posts = Post.with_attached_image.order(created_at: :desc)
  end

  def new
    @post = current_user.posts.new
  end

  def create
    @post = current_user.posts.build(post_params)
    @post.comments&.first&.user = current_user

    if @post.save
      redirect_to posts_path, notice: "Created Post"
    else
      render :new, notice: "Please try again"
    end
  end

  def show
    @posts = tagged
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to user_path(@post.user.username), notice: "Post Deleted"
  end

  def tagged
    if params[:tag].present?
      @posts = Post.tagged_with(params[:tag])
    else
      @posts = Post.all
    end
    if @posts.nil?
      redirect_to explore_posts_path, notice: "No posts with that tag"
    else
      return @posts
    end
  end

  private

  def post_params
    params.require(:post).permit(:image, :tag_list, comments_attributes: [:body])
  end
end
