class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :other_user, only: [:show_other]

  def show
    @user = current_user
  end

  def show_other
    @user = current_user
  end

  private
    def other_user
      @other_user = User.find(params[:id])
      if @other_user == current_user
        redirect_to :action => 'show'
      end
    end
end
