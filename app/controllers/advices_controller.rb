class AdvicesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_user

  def create
    @concern = Concern.find(params[:concern_id])
    @advice = current_user.advices.new(advice_params)
    if @advice.save
      @concern.create_notification_advice!(current_user, @advice.id)
      redirect_to concern_path(@concern), notice: "アドバイスしました。"
    else
      flash[:notice] = "アドバイスが出来ませんでした。"
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @concern = Concern.find(params[:concern_id])
    @advice = @concern.advices.find(params[:id])
    if @advice.destroy
      redirect_to concern_path(@concern), notice: "アドバイスを削除しました。"
    else
      render concern_path(@concern), notice: "アドバイスの削除に失敗しました。"
    end
  end

  private

  def advice_params
    params.require(:advice).permit(:advice).merge(user_id: current_user.id, concern_id: params[:concern_id])
  end
end
