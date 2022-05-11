class RecommendsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_user
  before_action :set_recommend, only: [:show, :edit, :update, :destroy ]
  before_action :set_q, only: [:index, :search]

  def index
    @recommends = Recommend.includes(:user).page(params[:page]).per(5)
  end

  def show
  end
  def new
    @recommend = Recommend.new
  end

  def edit
  end

  def create
    @recommend = Recommend.new(recommend_params)
    if @recommend.save
      redirect_to @recommend, notice: "オススメを投稿しました。"
    else
      render :new
    end
  end

  def update
    if @recommend.update(recommend_params)
      redirect_to @recommend, notice: 'オススメを更新しました。'
    else
      render :edit
    end
  end

  def destroy
    @recommend.destroy
    redirect_to recommends_url, notice: 'オススメを削除しました。'
  end


  def search
    @results = @q.result.includes(:user)
  end

  private
  def set_recommend
    @recommend = Recommend.find(params[:id])
  end

  def set_q
    @q = Recommend.ransack(params[:q])
  end

  def recommend_params
      params.require(:recommend).permit(:title, :content, :image, :country_code, :address, :latitude, :longitude).merge(user_id: current_user.id)
  end
end
