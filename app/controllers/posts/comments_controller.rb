module Posts
  class CommentsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_post

    def create
      @comment = @post.comments.build(comments_params.merge(user: current_user))

      if @comment.save
        render partial: 'posts/comments/comment', locals: { comment: @comment }
      else
        render partial: 'posts/comments/error', locals: { comment: @comment }, status: :bad_request
      end
    end

    private

    def set_post
      @post = Post.find(params[:post_id])
    end

    def comments_params
      params.require(:comment).permit(:body)
    end
  end
end
