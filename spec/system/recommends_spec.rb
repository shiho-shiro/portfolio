require 'rails_helper'

RSpec.describe "Recommends", type: :system do
  let(:user_1) = (create :user)
  let(:user_2) = (create :user)
  let(:recommend_1) = (create :recommend, user_id :user_1.id)
  let(:recommend_2) = (create :recommend, user_id :user_2.id)
  let(:like_1) = (create :like, recommend_id :recommend_1.id, user_id :user_2.id)
  let(:like_2) = (create :likee,recommend_id :recommend_1.id, user_id :user_2.id)
  describe "投稿一覧" do
    context "ログイン済みのユーザーとして" do
      scenario "更新日が新しい順に表示される" do

      end

      scenario "タイトル、更新日、アカウント画像が表示される" do

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

      scenario "コンテンツが200文字以上はエラーコメントが表示" do

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

      scenario "コンテンツが200文字以上はエラーコメントが表示" do

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

  describe "アドバイス" do
    context "登録済みのユーザーとして" do
      scenario "アドバイスができる" do

      end
      scenario "100文字以上だとアドバイスできない" do

      end
    end

    context "未登録のゲストとして" do
      scenario "アドバイスできない" do

      end
    end
  end

  describe "検索" do
    context "登録済みのユーザーとして" do
      scenario "タイトル名が含まれている場合" do

      end

      scenario "タイトル名が空欄の場合" do

      end

      scenario "国名が含まれている場合" do

      end

      scenario "国名が空欄の場合" do

      end
    end

    context "未登録のゲストとして" do
      scenario "検索できない" do

      end
    end
  end
end
