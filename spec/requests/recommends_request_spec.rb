require 'rails_helper'

RSpec.describe RecommendsController, type: :request do
  before do
    @user = create(:user)
  end

  describe "#index" do
    context "登録済みのユーザーとして" do
      before do
        @recommend = create(:recommend, user_id: @user.id)
        sign_in @user
        get recommends_path
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
        @recommend = create(:recommend, user_id: @other_user.id)
        sign_in @user
        get recommends_path
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
        @recommend = create(:recommend, user_id: @user.id)
        get recommends_path
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
        @recommend = create(:recommend, user_id: @user.id)
        get recommend_path(@recommend.id)
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
        @recommend = create(:recommend, user_id: @user.id)
        sign_in @other_user
        get recommend_path(@recommend.id)
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
        @recommend = create(:recommend, user_id: @user.id)
        get recommend_path(@recommend.id)
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
        get new_recommend_path
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
        get new_recommend_path
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

      it "オススメを追加できる" do
        @recommend = attributes_for(:recommend, user_id: @user.id)
        expect do
          post recommends_path(recommend: @recommend)
        end.to change(@user.recommends, :count).by(1)
      end

      it "新しいオススメを作成後、詳細画面にリダイレクトされる" do
        @recommend = attributes_for(:recommend, user_id: @user.id)
        post recommends_path(recommend: @recommend)
        recommend = Recommend.last
        expect(response).to redirect_to recommend_path(recommend)
      end

      it "不正があった場合は登録されない" do
        @recommend = attributes_for(:recommend, title: nil, user_id: @user.id)
        expect do
          post recommends_path(recommend: @recommend)
        end.to change(@user.recommends, :count).by(0)
      end
    end

    context "未登録のゲストとして" do
      it "正常のレスポンスを返す" do
        @recommend = attributes_for(:recommend, user_id: @user.id)
        post recommends_path(recommend: @recommend)
        expect(response).not_to be_successful
      end

      it "302レスポンスを返す" do
        @recommend = attributes_for(:recommend, user_id: @user.id)
        post recommends_path(recommend: @recommend)
        expect(response).to have_http_status "302"
      end

      it "ログイン画面へリダイレクトする" do
        @recommend = attributes_for(:recommend, user_id: @user.id)
        post recommends_path(recommend: @recommend)
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "edit" do
    before do
      @recommend = create(:recommend, user_id: @user.id)
    end

    context "登録済みのユーザーとして" do
      before do
        sign_in @user
        get edit_recommend_path(@recommend.id)
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
        get edit_recommend_path(@recommend.id)
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
        @recommend = create(:recommend, user_id: @user.id)
      end

      it "オススメのタイトル名を変更できる" do
        recommend_title = attributes_for(:recommend, title: "オススメを変更しました")
        patch recommend_path(@recommend.id, recommend: recommend_title)
        expect(@recommend.reload.title).to eq "オススメを変更しました"
      end

      it "オススメを更新後、詳細画面にリダイレクトされる" do
        recommend_title = attributes_for(:recommend, title: "オススメを変更しました")
        patch recommend_path(@recommend.id, recommend: recommend_title)
        expect(response).to redirect_to recommend_path(@recommend)
      end

      it "不正があった場合は更新されない" do
        recommend_title = attributes_for(:recommend, title: nil)
        patch recommend_path(@recommend.id, recommend: recommend_title)
        expect(@recommend.reload.title).to eq "オススメのタイトル"
      end
    end

    context "未登録のゲストとして" do
      before do
        @recommend = create(:recommend, user_id: @user.id)
      end

      it "正常のレスポンスを返す" do
        recommend_title = attributes_for(:recommend, title: "オススメを変更しました")
        patch recommend_path(@recommend.id, recommend: recommend_title)
        expect(response).not_to be_successful
      end

      it "302レスポンスを返す" do
        recommend_title = attributes_for(:recommend, title: "オススメを変更しました")
        patch recommend_path(@recommend.id, recommend: recommend_title)
        expect(response).to have_http_status "302"
      end

      it "ログイン画面へリダイレクトする" do
        recommend_title = attributes_for(:recommend, title: "オススメを変更しました")
        patch recommend_path(@recommend.id, recommend: recommend_title)
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "destroy" do
    context "登録済みのユーザーとして" do
      before do
        sign_in @user
        @recommend = create(:recommend, user_id: @user.id)
      end

      it "正常に削除されているか" do
        expect do
          delete recommend_path(@recommend.id)
        end.to change(@user.recommends, :count).by(-1)
      end

      it "削除後オススメ一覧ページへリダイレクトされるか" do
        delete recommend_path(@recommend.id)
        expect(response).to redirect_to recommends_path
      end
    end

    context "他のユーザーとして" do
      before do
        @other_user = create(:user)
        @recommend = create(:recommend, user_id: @other_user.id)
        sign_in @user
      end

      it "削除出来ない" do
        expect do
          delete recommend_path(@recommend.id)
        end.to change(Recommend, :count)
      end
    end

    context "未登録のゲストとして" do
      before do
        @recommend = create(:recommend, user_id: @user.id)
      end

      it "302レスポンスを返す" do
        delete recommend_path(@recommend.id)
        expect(response).to have_http_status "302"
      end

      it "ログイン画面にリダイレクトされる" do
        delete recommend_path(@recommend.id)
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "search_recommends " do
    context "登録済みユーザーとして" do
      before do
        @recommend = create(:recommend, user_id: @user.id)
        @another_recommend = create(:recommend, user_id: @user.id)
        sign_in @user
        get search_recommends_path, params: { q: { title_cont: "オススメ" } }
      end

      it "200レスポンスを返す" do
        expect(response).to have_http_status "200"
      end

      it "正常のレスポンスを返す" do
        expect(response).to be_successful
      end

      it "タイトル名が表示されていること" do
        expect(response.body).to include(@recommend.title)
      end
    end

    context "国名を指定した場合" do
      before do
        @recommend = create(:recommend, user_id: @user.id)
        @another_recommend = create(:another_recommend, user_id: @user.id)
        sign_in @user
        get search_recommends_path, params: { q: { country_code_eq: "JP" } }
      end

      it "タイトル名が表示される" do
        expect(response.body).to include(@another_recommend.title)
      end
    end

    context "未登録のゲストとして" do
      before do
        @recommend = create(:recommend, user_id: @user.id)
        @another_recommend = create(:recommend, user_id: @user.id)
        get search_recommends_path, params: { q: { title_cont: "オススメ" } }
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
end
