class ConcernsController < ApplicationController
  before_action :set_concern, only: [:show, :edit, :update, :destroy]

  def index
    @user = current_user
    @concerns = Concern.includes(:user).order(created_at: :desc)
  end

  def show
    @user = current_user
  end

  def new
    @user = current_user
    @concern = Concern.new
  end

  def edit
    @user = current_user
  end

  def create
    @user = current_user
    @concern = Concern.new(concern_params)

    if @concern.save
      redirect_to @concern, notice: '投稿されました。'
    else
      render :new
    end
  end

  def update
    @user = current_user
    if @concern.update(concern_params)
      redirect_to @concern, notice: '投稿内容が変更されました。'
    else
      render :edit
    end
  end

  def destroy
    @user = current_user
    @concern.destroy
    redirect_to concerns_url, notice: '投稿が削除されました。'
  end

  private

    def set_concern
      @concern = Concern.find(params[:id])
    end

    def concern_params
      params.require(:concern).permit(:title, :content, :image).merge(user_id: current_user.id)
    end
end
