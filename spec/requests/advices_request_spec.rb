require 'rails_helper'

RSpec.describe AdvicesController, type: :request do
  before do
    @user = create(:user)
    @concern = create(:concern, user_id: @user.id)
    @advice = create(:advice, user_id: @user.id, concern_id: @concern.id)
  end

  describe "create" do
    context "登録済みのユーザーとして" do
      before do
        sign_in @user
        get concern_path(@concern.id)
      end

      it "お悩みを追加できる" do
        @advice = attributes_for(:advice, user_id: @user.id, concern_id: @concern.id)
        expect do
          post concern_advices_path(advice: @advice, concern_id: @concern.id)
        end.to change(@user.advices, :count).by(1)
      end

      it "新規アドバイス作成後、お悩み詳細画面にリダイレクトされる" do
        @advice = attributes_for(:advice, user_id: @user.id, concern_id: @concern.id)
        post concern_advices_path(advice: @advice, concern_id: @concern.id)
        concern = Concern.last
        expect(response).to redirect_to concern_path(concern)
      end

      it "不正があった場合は登録されない" do
        @advice = attributes_for(:advice, advice: nil, user_id: @user.id, concern_id: @concern.id)
        expect do
          post concern_advices_path(advice: @advice, concern_id: @concern.id)
        end.to change(@user.advices, :count).by(0)
      end
    end

    context "未登録のゲストとして" do
      before do
        get concern_path(@concern.id)
      end

      it "正常のレスポンスを返す" do
        @advice = attributes_for(:advice, user_id: @user.id, concern_id: @concern.id)
        post concern_advices_path(advice: @advice, concern_id: @concern.id)
        expect(response).not_to be_successful
      end

      it "302レスポンスを返す" do
        @advice = attributes_for(:advice, user_id: @user.id, concern_id: @concern.id)
        post concern_advices_path(advice: @advice, concern_id: @concern.id)
        expect(response).to have_http_status "302"
      end

      it "ログイン画面へリダイレクトする" do
        @advice = attributes_for(:advice, user_id: @user.id, concern_id: @concern.id)
        post concern_advices_path(advice: @advice, concern_id: @concern.id)
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "destroy" do
    context "登録済みのユーザーとして" do
      before do
        sign_in @user
        get concern_path(@concern.id)
      end

      it "正常に削除されているか" do
        expect do
          delete concern_advice_path(@advice.id, concern_id: @concern.id)
        end.to change(@user.advices, :count).by(-1)
      end

      it "削除後お悩み一覧ページへリダイレクトされるか" do
        delete concern_advice_path(@advice.id, concern_id: @concern.id)
        expect(response).to redirect_to concern_path(@concern.id)
      end
    end

    context "他のユーザーとして" do
      before do
        @other_user = create(:user)
        sign_in @other_user
        get concern_path(@concern.id)
      end

      it "削除出来ない" do
        expect do
          delete concern_advice_path(@advice.id, concern_id: @concern.id)
        end.to change(Advice, :count)
      end
    end

    context "未登録のゲストとして" do
      before do
        get concern_path(@concern.id)
      end

      it "302レスポンスを返す" do
        delete concern_advice_path(@advice.id, concern_id: @concern.id)
        expect(response).to have_http_status "302"
      end

      it "ログイン画面にリダイレクトされる" do
        delete concern_advice_path(@advice.id, concern_id: @concern.id)
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end
end
