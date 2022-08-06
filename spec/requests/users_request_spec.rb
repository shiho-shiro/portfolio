require 'rails_helper'

RSpec.describe UsersController, type: :request do
  before do
    @user = create(:user)
    @other_user = create(:user)
  end

  describe "show" do
    context "登録済みのユーザーとして" do
      before do
        sign_in @user
        get user_path(@user.id)
      end

      it "正常のレスポンスを返す" do
        expect(response).to be_successful
      end

      it "200レスポンスを返す" do
        expect(response).to have_http_status "200"
      end
    end

    context "未登録ゲストとして" do
      before do
        get user_path(@user)
      end

      it "正常のレスポンスを返す" do
        expect(response).not_to be_successful
      end

      it "302レスポンスを返す" do
        expect(response).to have_http_status "302"
      end
    end
  end

  describe "show_other" do
    context "@other_userがメインユーザーでない場合" do
      before do
        sign_in @other_user
        get show_other_user_path(@user)
      end

      it "正常なレスポンスを返す" do
        expect(response).to be_successful
      end

      it "200レスポンスを返す" do
        expect(response).to have_http_status "200"
      end
    end

    context "@other_userがメインユーザーの場合" do
      before do
        sign_in @other_user
        get show_other_user_path(@other_user)
      end

      it "正常なレスポンスを返す" do
        expect(response).not_to be_successful
      end

      it "302レスポンスを返す" do
        expect(response).to have_http_status "302"
      end

      it "メインユーザーの詳細画面へリダイレクトされる" do
        expect(response).to redirect_to user_path(@other_user)
      end
    end

    context "未登録のゲストとして" do
      before do
        get show_other_user_path(@other_user)
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
end
