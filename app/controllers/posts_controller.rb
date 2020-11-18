class PostsController < ApplicationController
  before_action :authenticate_user!, only: %i[:new, :create]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
    if user_signed_in?
      for post in @posts do
        if post.user_id?
          user = User.find_by_id(post.user_id)
          post.user = user
          
        end
      end
    else
      for post in @posts do
          post.user_id = -1
      end
    end
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
      if @post.save
        redirect_to posts_path
      else
        render :new
      end
  
  end

  private

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :description)
    end
end
