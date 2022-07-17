require 'rails_helper'

RSpec.describe "Memories", type: :system do
  let(:user) = (create :user)
  let(:memory_1) = (create :memory, user_id :user.id)
  let(:memory_2) = (create :memory, user_id :user.id)
  describe "投稿一覧" do
    context "ログイン済みのユーザーとして" do
      scenario "更新日が新しい順に表示される" do

      end

      scenario "タイトルをクリックすると、その投稿の詳細画面へリンクする" do

      end
    end
  end

  describe "Memoryの投稿" do
    context "ログイン済みのユーザーとして" do
      scenario "フォームの値が正常か" do

      end

      scenario "タイトルがnilの場合" do

      end

      scenario "コンテンツがnilの場合" do

      end

      scenario "国名がnilの場合" do

      end

      scenario "画像は投稿できるか" do

      end

      scenario "タイトルが20文字以上はエラーコメントが表示" do

      end

      scenario "コンテンツが300文字以上はエラーコメントが表示" do

      end
    end

    context "未登録のゲストとして" do
      scenario "投稿できない" do

      end
    end
  end

  describe "Memoryの編集" do
    context "ログイン済みのユーザーとして" do
      scenario "フォームの値が正常か" do

      end

      scenario "タイトルがnilの場合" do

      end

      scenario "コンテンツがnilの場合" do

      end

      scenario "国名がnilの場合" do

      end

      scenario "画像は投稿できるか" do

      end

      scenario "タイトルが20文字以上はエラーコメントが表示" do

      end

      scenario "コンテンツが300文字以上はエラーコメントが表示" do

      end
    end

    context "未登録のゲストして" do
      scenario "編集できない" do

      end
    end
  end

  describe "Memoryの削除" do
    context "登録済みのユーザーとして" do
      scenario "投稿を削除できる" do

      end
    end

    context "未登録のゲストとして" do
      scenario "削除できない" do

      end
    end
  end
end
