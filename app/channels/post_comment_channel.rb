class PostCommentChannel < ApplicationCable::Channel
  def subscribed
    stream_for(Post.find(params["post_id"]))
  end

  def unsubscribed
    stop_all_streams
  end
end
