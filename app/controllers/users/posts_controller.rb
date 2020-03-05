module Users
  class PostsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user

    def show
      @post = @user.posts.with_attached_image.find(params[:id])
      @comments = @post.comments.all
      @comment = @post.comments.new
    end

    private

    def set_user
      @user = User.find_by_username!(params[:user_username])
    end
  end
end
