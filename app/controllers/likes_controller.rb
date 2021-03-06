class LikesController < ApplicationController
  def create
    @like = current_user.likes.create(recommend_id: params[:recommend_id])
    @recommend = Recommend.find(params[:recommend_id])
    @recommend.create_notification_like!(current_user)
    redirect_to recommend_path(@recommend)
  end

  def destroy
    @recommend = Recommend.find(params[:recommend_id])
    @like = current_user.likes.find_by(recommend_id: @recommend.id)
    @like.destroy
    redirect_to recommend_path(@recommend)
  end
end
