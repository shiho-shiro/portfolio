require 'rails_helper'

RSpec.describe LikesController, type: :request do
  before do
    @user = create(:user)
    @other_user = create(:user)
    @recommend = create(:recommend, user_id: @user.id)
    @like = create(:like, user_id: @user.id, recommend_id: @recommend.id)
  end

  describe "create" do
    context "登録済みのユーザーとして" do
      before do
        sign_in @other_user
        get recommend_path(@recommend.id)
      end

      it "いいねが出来る" do
        @like = attributes_for(:like, user_id: @user.id, recommend_id: @recommend.id)
        expect do
          post recommend_likes_path(like: @like, recommend_id: @recommend.id)
        end.to change(@other_user.likes, :count).by(1)
      end

      it "新規アドバイス作成後、お悩み詳細画面にリダイレクトされる" do
        @like = attributes_for(:like, user_id: @user.id, recommend_id: @recommend.id)
        post recommend_likes_path(like: @like, recommend_id: @recommend.id)
        recommend = Recommend.last
        expect(response).to redirect_to recommend_path(recommend)
      end
    end

    context "登録済みの投稿者自身の場合" do
      it "自分の投稿にはいいねが出来ない" do
        sign_in @other_user
        get recommend_path(@recommend.id)
        @like = attributes_for(:like, user_id: @other_user.id, recommend_id: @recommend.id)
        expect do
          post recommend_likes_path(like: @like, recommend_id: @recommend.id)
        end.to change(@user.likes, :count).by(0)
      end
    end

    context "未登録のゲストとして" do
      before do
        get recommend_path(@recommend.id)
      end

      it "正常のレスポンスを返す" do
        @like = attributes_for(:like, user_id: @other_user.id, recommend_id: @recommend.id)
        post recommend_likes_path(like: @like, recommend_id: @recommend.id)
        expect(response).not_to be_successful
      end

      it "302レスポンスを返す" do
        @like = attributes_for(:like, user_id: @other_user.id, recommend_id: @recommend.id)
        post recommend_likes_path(like: @like, recommend_id: @recommend.id)
        expect(response).to have_http_status "302"
      end

      it "ログイン画面へリダイレクトする" do
        @like = attributes_for(:like, user_id: @other_user.id, recommend_id: @recommend.id)
        post recommend_likes_path(like: @like, recommend_id: @recommend.id)
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "destroy" do
    context "登録済みのユーザーとして" do
      before do
        sign_in @user
        get recommend_path(@recommend.id)
      end

      it "正常に削除されているか" do
        expect do
          delete recommend_likes_path(like: @like, recommend_id: @recommend.id)
        end.to change(@user.likes, :count).by(-1)
      end

      it "削除後オススメ一覧ページへリダイレクトされるか" do
        delete recommend_likes_path(like: @like, recommend_id: @recommend.id)
        expect(response).to redirect_to recommend_path(@recommend.id)
      end
    end

    context "未登録のゲストとして" do
      before do
        get recommend_path(@recommend.id)
      end

      it "302レスポンスを返す" do
        delete recommend_likes_path(like: @like, recommend_id: @recommend.id)
        expect(response).to have_http_status "302"
      end

      it "ログイン画面にリダイレクトされる" do
        delete recommend_likes_path(like: @like, recommend_id: @recommend.id)
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end
end
