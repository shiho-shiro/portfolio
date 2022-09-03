class MemoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_user
  before_action :set_memory, only: [:show, :edit, :update, :destroy]

  def index
    @memories = @user.memories.order(date: :desc).page(params[:page]).per(5)
  end

  def show
    if @memory.user == current_user
      render "show"
    else
      redirect_to root_path
    end
  end

  def new
    @memory = Memory.new
  end

  def edit
    if @memory.user == current_user
      render "edit"
    else
      redirect_to root_path
    end
  end

  def create
    @memory = Memory.new(memory_params)
    if @memory.save
      redirect_to @memory, notice: 'Memoryを作成しました'
    else
      render :new
    end
  end

  def update
    if @memory.update(memory_params)
      redirect_to @memory, notice: 'Memoryを更新しました。'
    else
      render :edit
    end
  end

  def destroy
    @memory.destroy
    redirect_to memories_path, notice: 'Memoryを削除しました。'
  end

  def remove_image
    @memory = Memory.find(params[:id])
    if @memory.image.attached?
      if @memory.image.purge
        redirect_to memorys_path
      else
        render :edit
      end
    end
  end

  private

  def set_memory
    @memory = Memory.find(params[:id])
  end

  def memory_params
    params.require(:memory).permit(:title, :content, :date, :image).merge(user_id: current_user.id)
  end
end
