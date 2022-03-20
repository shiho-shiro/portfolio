class MemoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_user
  before_action :set_memory, only: [:show, :edit, :update, :destroy]
  before_action :memory_user, only: [:show_other_index]
  def index
    @user = current_user
    @memories = @user.memories
  end

  def show_other_index
    @user = current_user
  end

  def show
    @user = current_user
  end

  def new
    @user = current_user
    @memory = Memory.new
  end

  def edit
    @user = current_user
  end

  def create
    @user = current_user
    @memory = Memory.new(memory_params)

    if @memory.save
      redirect_to @memory, notice: 'Memoryを作成しました'
    else
      render :new
    end
  end


  def update
    @user = current_user
    if @memory.update(memory_params)
      redirect_to @memory, notice: 'Memoryを更新しました。'
    else
      render :edit
    end
  end

  def destroy
    @user = current_user
    @memory.destroy
    redirect_to memories_url, notice: 'Memoryを削除しました。'
  end

  private
    def set_memory
      @memory = Memory.find(params[:id])
    end

    def memory_params
      params.require(:memory).permit(:title, :content, :date, :image).merge(user_id: current_user.id)
    end

    def memory_user
      @other_user = User.find(params[:id])
      @memories = @other_user.memories
      if @other_user == current_user
        redirect_to :action => 'index'
      end
    end
end
