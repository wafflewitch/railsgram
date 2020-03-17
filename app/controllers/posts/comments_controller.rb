module Posts
  class CommentsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_post

    def create
      @comment = @post.comments.build(comments_params.merge(user: current_user))

      if @comment.save
        PostCommentChannel.broadcast_to(@post, comment_created_params)
        # render partial: 'posts/comments/comment', locals: { comment: @comment }
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

    def destroy
      @comment = @post.comments.find(params[:id])
      @comment.destroy
      PostCommentChannel.broadcast_to(@post, comment_destroyed_params)
    end

    private

    def comment_destroyed_params
      { action: :destroy, comment_id: @comment.id }
    end

    def comment_created_params
      { action: :created, html: comment_html }
    end

    def comment_html
      ApplicationController.renderer.render(
        partial: "posts/comments/comment",
        locals: { comment: @comment, realtime: true },
        format: :html
      )
    end

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
