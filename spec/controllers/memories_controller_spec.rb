require 'rails_helper'

RSpec.describe MemoriesController, type: :controller do
  before do
    @user = create(:user)
  end

  describe "#index" do
    context "登録済みのユーザーとして" do
      before do
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
    before do
      @memory = create(:memory, user_id: @user.id)
    end

    context "登録済みのユーザーとして" do
      before do
        sign_in @user
        get :show, params: { id: @memory.id }
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
        get :show, params: { id: @memory.id }
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

  describe "show_other_index" do
    before do
      @other_user = create(:user)
      @memory = create(:memory, user_id: @other_user.id)
    end

    context "user =! other_user の場合" do
      before do
        sign_in @user
        get :show_other_index, params: { id: @other_user.id }
      end

      it "正常なレスポンスを返す" do
        expect(response).to be_successful
      end

      it "200レスポンスを返す" do
        expect(response).to have_http_status "200"
      end
    end

    context "user == other_user の場合" do
      before do
        sign_in @other_user
        get :show_other_index, params: { id: @other_user.id }
      end

      it "正常なレスポンスを返す" do
        expect(response).not_to be_successful
      end

      it "302レスポンスを返す" do
        expect(response).to have_http_status "302"
      end

      it "memory一覧画面へリダイレクトする" do
        expect(response).to redirect_to "/memories"
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

      it "memoryを追加できる" do
        @memory = attributes_for(:memory, user_id: @user.id)
        expect do
          post :create, params: { memory: @memory }
        end.to change(@user.memories, :count).by(1)
      end

      it "新しいMemoryを作成後、詳細画面にリダイレクトされる" do
        @memory = attributes_for(:memory, user_id: @user.id)
        post :create, params: { memory: @memory }
        memory = Memory.last
        expect(response).to redirect_to memory_path(memory)
      end

      it "不正があった場合は登録されない" do
        @memory = attributes_for(:memory, title: nil, user_id: @user.id)
        expect do
          post :create, params: { memory: @memory }
        end.to change(@user.memories, :count).by(0)
      end
    end

    context "未登録のゲストとして" do
      it "正常のレスポンスを返す" do
        @memory = attributes_for(:memory, user_id: @user.id)
        post :create, params: { memory: @memory }
        expect(response).not_to be_successful
      end

      it "302レスポンスを返す" do
        @memory = attributes_for(:memory, user_id: @user.id)
        post :create, params: { memory: @memory }
        expect(response).to have_http_status "302"
      end

      it "ログイン画面へリダイレクトする" do
        @memory = attributes_for(:memory, user_id: @user.id)
        post :create, params: { memory: @memory }
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "edit" do
    before do
      @memory = create(:memory, user_id: @user.id)
    end

    context "登録済みのユーザーとして" do
      before do
        sign_in @user
        get :edit, params: { id: @memory.id }
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
        get :edit, params: { id: @memory.id }
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
        @memory = create(:memory, user_id: @user.id)
      end

      it "memoryのタイトル名を変更できる" do
        memory_title = attributes_for(:memory, title: "変更しました")
        patch :update, params: { id: @memory.id, memory: memory_title }
        expect(@memory.reload.title).to eq "変更しました"
      end

      it "Memory更新後、詳細画面にリダイレクトされる" do
        memory_title = attributes_for(:memory, title: "変更しました")
        patch :update, params: { id: @memory.id, memory: memory_title }
        expect(response).to redirect_to memory_path(@memory)
      end

      it "不正があった場合は更新されない" do
        memory_title = attributes_for(:memory, title: nil)
        patch :update, params: { id: @memory.id, memory: memory_title }
        expect(@memory.reload.title).to eq "memoryのタイトル"
      end
    end

    context "未登録のゲストとして" do
      before do
        @memory = create(:memory, user_id: @user.id)
      end

      it "正常のレスポンスを返す" do
        memory_title = attributes_for(:memory, title: "変更しました")
        patch :update, params: { id: @memory.id, memory: memory_title }
        expect(response).not_to be_successful
      end

      it "302レスポンスを返す" do
        memory_title = attributes_for(:memory, title: "変更しました")
        patch :update, params: { id: @memory.id, memory: memory_title }
        expect(response).to have_http_status "302"
      end

      it "ログイン画面へリダイレクトする" do
        memory_title = attributes_for(:memory, title: "変更しました")
        patch :update, params: { id: @memory.id, memory: memory_title }
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "destroy" do
    context "登録済みのユーザーとして" do
      before do
        sign_in @user
        @memory = create(:memory, user_id: @user.id)
      end

      it "正常に削除されているか" do
        expect do
          delete :destroy, params: { id: @memory.id }
        end.to change(@user.memories, :count).by(-1)
      end

      it "削除後Memory一覧ページへリダイレクトされるか" do
        delete :destroy, params: { id: @memory.id }
        expect(response).to redirect_to memories_path
      end
    end

    context "他のユーザーとして" do
      before do
        @other_user = create(:user)
        @memory = create(:memory, user_id: @other_user.id)
        sign_in @user
      end

      it "削除出来ない" do
        expect do
          delete :destroy, params: { id: @memory.id }
        end.to change(Memory, :count)
      end
    end

    context "未登録のゲストとして" do
      before do
        @memory = create(:memory, user_id: @user.id)
      end

      it "302レスポンスを返す" do
        delete :destroy, params: { id: @memory.id }
        expect(response).to have_http_status "302"
      end

      it "ログイン画面にリダイレクトされる" do
        delete :destroy, params: { id: @memory.id }
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end
end
