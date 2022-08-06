require 'rails_helper'

RSpec.describe NotificationsController, type: :request do
  before do
    @user = create(:user)
    @another_user = create(:another_user)
    @recommend = create(:recommend)
    @concern = create(:concern)
    @advice = create(:advice)
    @notification = create(:notification, concern_id: @concern.id, recommend_id: @recommend.id, advice_id: @advice.id, visiter_id: @another_user.id, visited_id: @user.id)
  end

  describe "index" do
    context "登録済みのユーザーとして" do
      before do
        sign_in @user
        get notifications_path
      end

      it "正常なレスポンスを返す" do
        expect(response).to be_successful
      end

      it "200レスポンスを返す" do
        expect(response).to have_http_status "200"
      end
    end

    context "未登録のゲストとして" do
      before do
        get notifications_path
      end

      it "正常なレスポンスを返す" do
        expect(response).not_to be_successful
      end

      it "302レスポンスを返す" do
        expect(response).to have_http_status "302"
      end

      it "ログイン画面へリダイレクトされる" do
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "destroy" do
    context "登録済みのユーザーとして" do
      before do
        sign_in @user
      end

      it "正常に削除されているか" do
        expect do
          delete notification_path(id: @notification.id)
        end.to change(Notification, :count).by(-1)
      end

      it "通知を削除後、通知一覧にリダイレクトされているか" do
        delete notification_path(@notification.id)
        expect(response).to redirect_to notifications_path
      end
    end

    context "未登録のゲストとして" do
      it "302レスポンスを返す" do
        delete notification_path(@notification.id)
        expect(response).to have_http_status "302"
      end

      it "ログイン画面へリダイレクトされる" do
        delete notification_path(@notification.id)
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end
end
