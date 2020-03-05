module Posts
  class LikesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_post

    def create
      @post.likes.where(user: current_user).first_or_create

      respond_to do |format|
        format.html { redirect_to user_post_path(@post.user.username, @post) }
        format.js
      end
    end

    def destroy
      @post.likes.where(user: current_user).destroy_all

      respond_to do |format|
        format.html { redirect_to user_post_path(@post.user.username, @post) }
        format.js
      end
    end

    private

    def set_post
      @post = Post.find(params[:post_id])
    end
  end
end
