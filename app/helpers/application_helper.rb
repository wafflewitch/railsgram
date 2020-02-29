module ApplicationHelper
  def bootstrap_class_for(flash_type)
    {
      success: 'alert-success',
      error: 'alert-danger',
      alert: 'alert-warning',
      notice: 'alert-info'
    }.stringify_keys[flash_type.to_s] || flash_type.to_s
  end

  def avatar_url_for(user, opts={})
    size = opts[:size] || 32

    if user.avatar.attached?
      user.avatar.variant(
        resize: "#{size}x#{size}!")
    else
      hash = Digest::MD5.hexdigest(user.email.downcase)
      "https://secure.gravatar.com/avatar/#{hash}.png?s=#{size}"
    end
  end
end
