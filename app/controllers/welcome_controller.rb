class WelcomeController < ApplicationController
  def index
    redirect_to posts_path if user_signed_in?
  end
end
