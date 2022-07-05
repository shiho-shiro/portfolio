require 'rails_helper'

RSpec.describe ConcernsController, type: :controller do
  before do
    @user = create(:user)
  end

  describe "#index" do
    context "登録済みのユーザーとして" do
      before do
        @concern = create(:concern, user_id: @user.id)
        sign_in @user
        get :index
      end

      it "200レスポンスを返す" do
        expect(response).to have_http_status "200"
      end

      it "正常のレスポンスを返す" do
        expect(response).to be_successful
      end
    end

    context "登録済みの他のユーザーとして" do
      before do
        @other_user = create(:user)
        @concern = create(:concern, user_id: @other_user.id)
        sign_in @user
        get :index
      end

      it "200レスポンスを返す" do
        expect(response).to have_http_status "200"
      end

      it "正常のレスポンスを返す" do
        expect(response).to be_successful
      end
    end

    context "未登録のゲストとして" do
      before do
        @concern = create(:concern, user_id: @user.id)
        get :index
      end

      it "302レスポンスを返す" do
        expect(response).to have_http_status "302"
      end

      it "正常のレスポンスを返す" do
        expect(response).not_to be_successful
      end

      it "ログイン画面へリダイレクトする" do
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "show" do
    context "登録済みのユーザーとして" do
      before do
        sign_in @user
        @concern = create(:concern, user_id: @user.id)
        get :show, params: { id: @concern.id }
      end

      it "正常のレスポンスを返す" do
        expect(response).to be_successful
      end

      it "200レスポンスを返す" do
        expect(response).to have_http_status "200"
      end
    end

    context "登録済みの他のユーザーとして" do
      before do
        @other_user = create(:user)
        @concern = create(:concern, user_id: @user.id)
        sign_in @other_user
        get :show, params: { id: @concern.id }
      end

      it "正常のレスポンスを返す" do
        expect(response).to be_successful
      end

      it "200レスポンスを返す" do
        expect(response).to have_http_status "200"
      end
    end

    context "未登録のゲストとして" do
      before do
        @concern = create(:concern, user_id: @user.id)
        get :show, params: { id: @concern.id }
      end

      it "正常なレスポンスを返す" do
        expect(response).not_to be_successful
      end

      it "302レスポンスを返す" do
        expect(response).to have_http_status "302"
      end

      it "ログイン画面へリダイレクトする" do
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "new" do
    context "登録済みのユーザーとして" do
      before do
        sign_in @user
        get :new
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
        get :new
      end

      it "正常なレスポンスを返す" do
        expect(response).not_to be_successful
      end

      it "302レスポンスを返す" do
        expect(response).to have_http_status "302"
      end

      it "ログイン画面へリダイレクトする" do
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "create" do
    context "登録済みのユーザーとして" do
      before do
        sign_in @user
      end

      it "お悩みを追加できる" do
        @concern = attributes_for(:concern, user_id: @user.id)
        expect do
          post :create, params: { concern: @concern }
        end.to change(@user.concerns, :count).by(1)
      end

      it "新しいお悩みを作成後、詳細画面にリダイレクトされる" do
        @concern = attributes_for(:concern, user_id: @user.id)
        post :create, params: { concern: @concern }
        concern = Concern.last
        expect(response).to redirect_to concern_path(concern)
      end

      it "不正があった場合は登録されない" do
        @concern = attributes_for(:concern, title: nil, user_id: @user.id)
        expect do
          post :create, params: { concern: @concern }
        end.to change(@user.concerns, :count).by(0)
      end
    end

    context "未登録のゲストとして" do
      it "正常のレスポンスを返す" do
        @concern = attributes_for(:concern, user_id: @user.id)
        post :create, params: { concern: @concern }
        expect(response).not_to be_successful
      end

      it "302レスポンスを返す" do
        @concern = attributes_for(:concern, user_id: @user.id)
        post :create, params: { concern: @concern }
        expect(response).to have_http_status "302"
      end

      it "ログイン画面へリダイレクトする" do
        @concern = attributes_for(:concern, user_id: @user.id)
        post :create, params: { concern: @concern }
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "edit" do
    before do
      @concern = create(:concern, user_id: @user.id)
    end

    context "登録済みのユーザーとして" do
      before do
        sign_in @user
        get :edit, params: { id: @concern.id }
      end

      it "正常のレスポンスを返す" do
        expect(response).to be_successful
      end

      it "200レスポンスを返す" do
        expect(response).to have_http_status "200"
      end
    end

    context "未登録のゲストとして" do
      before do
        get :edit, params: { id: @concern.id }
      end

      it "正常のレスポンスを返す" do
        expect(response).not_to have_http_status "200"
      end

      it "302レスポンスを返す" do
        expect(response).to have_http_status "302"
      end

      it "ログイン画面へリダイレクトする" do
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "update" do
    context "登録済みのユーザーとして" do
      before do
        sign_in @user
        @concern = create(:concern, user_id: @user.id)
      end

      it "お悩みのタイトル名を変更できる" do
        concern_title = attributes_for(:concern, title: "お悩みを変更しました")
        patch :update, params: { id: @concern.id, concern: concern_title }
        expect(@concern.reload.title).to eq "お悩みを変更しました"
      end

      it "お悩みを更新後、詳細画面にリダイレクトされる" do
        concern_title = attributes_for(:concern, title: "お悩みを変更しました")
        patch :update, params: { id: @concern.id, concern: concern_title }
        expect(response).to redirect_to concern_path(@concern)
      end

      it "不正があった場合は更新されない" do
        concern_title = attributes_for(:concern, title: nil)
        patch :update, params: { id: @concern.id, concern: concern_title }
        expect(@concern.reload.title).to eq "お悩みのタイトル"
      end
    end

    context "未登録のゲストとして" do
      before do
        @concern = create(:concern, user_id: @user.id)
      end

      it "正常のレスポンスを返す" do
        concern_title = attributes_for(:concern, title: "お悩みを変更しました")
        patch :update, params: { id: @concern.id, concern: concern_title }
        expect(response).not_to be_successful
      end

      it "302レスポンスを返す" do
        concern_title = attributes_for(:concern, title: "お悩みを変更しました")
        patch :update, params: { id: @concern.id, concern: concern_title }
        expect(response).to have_http_status "302"
      end

      it "ログイン画面へリダイレクトする" do
        concern_title = attributes_for(:concern, title: "お悩みを変更しました")
        patch :update, params: { id: @concern.id, concern: concern_title }
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "destroy" do
    context "登録済みのユーザーとして" do
      before do
        sign_in @user
        @concern = create(:concern, user_id: @user.id)
      end

      it "正常に削除されているか" do
        expect do
          delete :destroy, params: { id: @concern.id }
        end.to change(@user.concerns, :count).by(-1)
      end

      it "削除後お悩み一覧ページへリダイレクトされるか" do
        delete :destroy, params: { id: @concern.id }
        expect(response).to redirect_to concerns_path
      end
    end

    context "他のユーザーとして" do
      before do
        @other_user = create(:user)
        @concern = create(:concern, user_id: @other_user.id)
        sign_in @user
      end

      it "削除出来ない" do
        expect do
          delete :destroy, params: { id: @concern.id }
        end.to change(Concern, :count)
      end
    end

    context "未登録のゲストとして" do
      before do
        @concern = create(:concern, user_id: @user.id)
      end

      it "302レスポンスを返す" do
        delete :destroy, params: { id: @concern.id }
        expect(response).to have_http_status "302"
      end

      it "ログイン画面にリダイレクトされる" do
        delete :destroy, params: { id: @concern.id }
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end
end
