class UsersController < ApplicationController
  def show
    @user = User.find_by!(username: params[:username])
    @posts = @user.posts.with_attached_image.order(created_at: :desc)
  end
end
