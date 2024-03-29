class ConcernsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_user
  before_action :set_concern, only: [:show, :edit, :update, :destroy]
  before_action :set_q, only: [:index, :search]

  def index
    @concerns = Concern.includes(:user).order(created_at: :desc).page(params[:page]).per(5)
  end

  def show
    @advice = Advice.new
    @advices = @concern.advices.order(created_at: :desc).page(params[:page]).per(5)
  end

  def new
    @concern = Concern.new
  end

  def edit
  end

  def create
    @concern = Concern.new(concern_params)
    if @concern.save
      redirect_to @concern, notice: 'お悩みを投稿しました。'
    else
      render :new
    end
  end

  def update
    if @concern.update(concern_params)
      redirect_to @concern, notice: '投稿内容が変更されました。'
    else
      render :edit
    end
  end

  def destroy
    if @concern.destroy
      redirect_to concerns_path, notice: '投稿が削除されました。'
    else
      render :edit
    end
  end

  def search
    @concern_results = @q.result.includes(:user).order(created_at: :desc).page(params[:page]).per(5)
  end

  def remove_image
    @concern = Concern.find(params[:id])
    if @concern.image.attached?
      if @concern.image.purge
        redirect_to concerns_path
      else
        render :edit
      end
    end
  end

  private

  def set_concern
    @concern = Concern.find(params[:id])
  end

  def set_q
    @q = Concern.ransack(params[:q])
  end

  def concern_params
    params.require(:concern).permit(:country_code, :title, :content, :image).merge(user_id: current_user.id)
  end
end
