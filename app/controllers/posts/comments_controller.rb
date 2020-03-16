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

    def show
      @comments = @post.comments
        .where("created_at < ?", DateTime.parse(params[:last_result_timestamp]))
        .order(created_at: :desc)
        .limit(5)
    end

    private

    def more_records?(post, last_result)
      post.comments.where("created_at < ?", last_result.created_at).any?
    end
    helper_method :more_records?

    def set_post
      @post = Post.find(params[:post_id])
    end

    def comments_params
      params.require(:comment).permit(:body)
    end
  end
end
