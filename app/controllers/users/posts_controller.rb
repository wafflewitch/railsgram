module Users
  class PostsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user

    def show
      @post = @user.posts.with_attached_image.find(params[:id])
      @comments = @post.comments.order(created_at: :desc).limit(5)
      @comment = @post.comments.new
    end

    private

    def more_records?(post, last_result)
      post.comments.where("created_at < ?", last_result.created_at).any?
    end
    helper_method :more_records?

    def set_user
      @user = User.find_by_username!(params[:user_username])
    end
  end
end
