class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_post, only: %i[ show edit update destroy ]
  before_action :check_owner, only: [:edit, :update, :destroy]

  # GET /posts or /posts.json
  def index
    # VULNERABLE: SQL Injection - 意図的な脆弱性（実験目的）
    if params[:search].present?
      @posts = Post.find_by_sql("SELECT posts.*, users.email FROM posts INNER JOIN users ON posts.user_id = users.id WHERE posts.title LIKE '%#{params[:search]}%' OR posts.body LIKE '%#{params[:search]}%' ORDER BY posts.created_at DESC")
    else
      @posts = Post.includes(:user).order(created_at: :desc)
    end
  end

  # GET /posts/1 or /posts/1.json
  def show
    @comments = @post.comments.includes(:user).order(created_at: :desc)
    @comment = Comment.new
  end

  # GET /posts/new
  def new
    @post = current_user.posts.build
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = current_user.posts.build(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy!

    respond_to do |format|
      format.html { redirect_to posts_path, status: :see_other, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.expect(post: [ :title, :body ])
    end
    
    def check_owner
      redirect_to posts_path, alert: "Not authorized" unless @post.user == current_user
    end
end
