require 'rails_helper'

RSpec.describe "User", type: :system do
  xdescribe "新規登録" do
    before do
      visit root_path
    end

    scenario "新規登録がページに表示されているか" do
      expect(page).to have_content "新規登録"
    end

    scenario "フォームの値が正常" do
      visit new_user_registration_path
      fill_in('user_username', with: 'シロ')
      fill_in('user_email', with: 'wanwan@test.com')
      fill_in('user_password', with: 'password')
      fill_in('user_password_confirmation', with: 'password')
      click_button("アカウント登録")
      expect(current_path).to eq root_path
      expect(page).to have_content "アカウント登録が完了しました。"
    end

    scenario "ユーザー名が未入力" do
      visit new_user_registration_path
      fill_in('user_username', with: '')
      fill_in('user_email', with: 'wanwan@test.com')
      fill_in('user_password', with: 'password')
      fill_in('user_password_confirmation', with: 'password')
      click_button("アカウント登録")
      expect(page).to have_content "ユーザー名を入力してください"
    end

    scenario "メールアドレスが未入力" do
      visit new_user_registration_path
      fill_in('user_username', with: 'シロ')
      fill_in('user_email', with: '')
      fill_in('user_password', with: 'password')
      fill_in('user_password_confirmation', with: 'password')
      click_button("アカウント登録")
      expect(page).to have_content "メールアドレスを入力してください"
    end

    scenario "パスワードが未入力" do
      visit new_user_registration_path
      fill_in('user_username', with: 'シロ')
      fill_in('user_email', with: 'wanwan@test.com')
      fill_in('user_password', with: '')
      fill_in('user_password_confirmation', with: 'password')
      click_button("アカウント登録")
      expect(page).to have_content "パスワードを入力してください"
    end

    scenario "確認用パスワードが不一致" do
      visit new_user_registration_path
      fill_in('user_username', with: 'シロ')
      fill_in('user_email', with: 'wanwan@test.com')
      fill_in('user_password', with: 'password')
      fill_in('user_password_confirmation', with: 'no')
      click_button("アカウント登録")
      expect(page).to have_content "確認用パスワードとパスワードの入力が一致しません"
    end
  end

  describe "登録済みのユーザーとして" do
    let(:user) { create(:user) }

    context "ログイン" do
      before do
        visit new_user_session_path
      end
      scenario "フォームの値が正常か" do
        fill_in('user_email', with: user.email)
        fill_in('user_password', with: user.password)
        click_button("ログイン")
        expect(current_path).to eq root_path
        expect(page).to have_content "ログインしました。"
      end

      scenario "メールアドレス未入力" do
        fill_in('user_email', with:'')
        fill_in('user_password', with: user.password)
        click_button("ログイン")
        expect(page).to have_content "メールアドレスまたはパスワードが違います。"
      end

      scenario "パスワード未入力" do
        fill_in('user_email', with:user.email)
        fill_in('user_password', with: '')
        click_button("ログイン")
        expect(page).to have_content "メールアドレスまたはパスワードが違います。"
      end
    end

    context "ログイン後" do
      before do
        login(user)
        visit root_path
      end

      scenario "アカウント画像・ユーザー名の表示" do
        expect(page).to have_content "#{Rails.root}/spec/fixtures/no_image.jpg"
      end

      scenario "Memory, お悩み相談、オススメ、通知が表示されているか" do
        expect(page).to have_content 'Memory'
        expect(page).to have_content 'お悩み相談'
        expect(page).to have_content 'オススメ'
        expect(page).to have_content '通知'
      end

      scenario "ログアウト", js: true do
        click_button 'ログアウト'
        expect(current_path).to eq root_path
        expect(page).to have_content 'ログアウトしました。'
      end

      scenario "ユーザー削除" do
        visit user_path(user.id)
        click_link '編集する'
        visit edit_user_registration_path
        click_button 'アカウント削除'
        expect{ click_on('アカウント削除')}.to change { User.count }.by(-1)
        expect(current_path).to eq root_path
        expect(page).to have_content 'アカウントを削除しました。またのご利用をお待ちしております。'
      end
    end

    xcontext "ユーザー編集" do
      scenario "フォームの値が正常" do

      end

      scenario "初期設定画像から指定した画像へ変更" do

      end

      scenario "ユーザー名未入力" do

      end

      scenario "メールアドレス未入力" do

      end

      scenario "国名未入力" do

      end

      scenario "確認用パスワードが不一致" do

      end

      scenario "仕事未入力" do

      end

      scenario "パスワードが未入力" do

      end
    end
  end

  xdescribe "未登録のゲストとして" do
    scenario "メールアドレス未入力" do

    end

    scenario "パスワード未入力" do

    end
  end
end
