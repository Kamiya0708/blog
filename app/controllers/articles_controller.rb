class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]

  # GET /articles
  # GET /articles.json
  def index
    @q = Article.ransack(params[:q])
    @articles = @q.result(distinct: true).page(params[:page]).per(20)
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = Article.new(article_params)
    respond_to do |format|
      if @article.save
        setup_images()
        format.html { redirect_to @article, notice: '記事を作成しました。' }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    setup_images()
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to @article, notice: '記事を更新しました。' }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article.images.purge if @article.images.attached?
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url, notice: '記事を削除しました。' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.require(:article).permit(:title, :content, :thumbnail, images: [])
    end

    def setup_images
      unless params[:images_name].blank?
        # 新しい画像の実体を取得
        new_blobs = ActiveStorage::Blob.where(filename: params[:images_name].split(","))
        # 古い画像とモデルの関連付けを解除
        @article.images.detach if @article.images.attached?
        # 新しい画像をモデルと関連付け
        @article.images.attach(new_blobs)
        # モデルと関連付けされていない実体ファイルをすべて削除
        ActiveStorage::Blob.unattached.find_each(&:purge)
      end
    end
end
