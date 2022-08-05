require 'rails_helper'

RSpec.describe "User", type: :system do
  describe "新規登録" do
    before do
      visit root_path
    end

    scenario "新規登録がページに表示されているか" do
      expect(page).to have_content '新規登録'
    end

    scenario "フォームの値が正常" do
      visit new_user_registration_path
      fill_in('user_username', with: 'シロ')
      fill_in('user_email', with: 'wanwan@test.com')
      fill_in('user_password', with: 'password')
      fill_in('user_password_confirmation', with: 'password')
      click_button("アカウント登録")
      expect(current_path).to eq root_path
      expect(page).to have_content 'アカウント登録が完了しました。'
    end

    scenario "ユーザー名が未入力" do
      visit new_user_registration_path
      fill_in('user_username', with: '')
      fill_in('user_email', with: 'wanwan@test.com')
      fill_in('user_password', with: 'password')
      fill_in('user_password_confirmation', with: 'password')
      click_button("アカウント登録")
      expect(page).to have_content 'ユーザー名を入力してください'
    end

    scenario "メールアドレスが未入力" do
      visit new_user_registration_path
      fill_in('user_username', with: 'シロ')
      fill_in('user_email', with: '')
      fill_in('user_password', with: 'password')
      fill_in('user_password_confirmation', with: 'password')
      click_button("アカウント登録")
      expect(page).to have_content 'メールアドレスを入力してください'
    end

    scenario "パスワードが未入力" do
      visit new_user_registration_path
      fill_in('user_username', with: 'シロ')
      fill_in('user_email', with: 'wanwan@test.com')
      fill_in('user_password', with: '')
      fill_in('user_password_confirmation', with: 'password')
      click_button("アカウント登録")
      expect(page).to have_content 'パスワードを入力してください'
    end

    scenario "確認用パスワードが不一致" do
      visit new_user_registration_path
      fill_in('user_username', with: 'シロ')
      fill_in('user_email', with: 'wanwan@test.com')
      fill_in('user_password', with: 'password')
      fill_in('user_password_confirmation', with: 'no')
      click_button("アカウント登録")
      expect(page).to have_content '確認用パスワードとパスワードの入力が一致しません'
    end
  end

  describe "未登録のゲストとして" do
    scenario "ログイン画面が表示される" do
      visit memories_path
      expect(current_path).to eq new_user_session_path
      expect(page).to have_content 'ログインもしくはアカウント登録してください。'
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
        expect(page).to have_content 'ログインしました。'
        expect(page).to have_selector("img[src$='no_image.jpg']")
      end

      scenario "メールアドレス未入力" do
        fill_in('user_email', with: '')
        fill_in('user_password', with: user.password)
        click_button("ログイン")
        expect(page).to have_content 'メールアドレスまたはパスワードが違います。'
      end

      scenario "パスワード未入力" do
        fill_in('user_email', with: user.email)
        fill_in('user_password', with: '')
        click_button("ログイン")
        expect(page).to have_content 'メールアドレスまたはパスワードが違います。'
      end
    end

    context "ログイン後" do
      before do
        login(user)
        visit root_path
      end

      scenario "Memory, お悩み相談、オススメ、通知が表示されているか" do
        expect(page).to have_content 'Memory'
        expect(page).to have_content 'お悩み相談'
        expect(page).to have_content 'オススメ'
        expect(page).to have_content '通知'
      end

      scenario "ログアウトの文字が表示されるか" do
        find(".dropdown-toggle").click
        expect(page).to have_content 'ログアウト'
      end

      scenario "ログアウトが出来るか" do
        find(".dropdown-toggle").click
        expect(page).to have_content 'ログアウト'
        click_on 'ログアウト'
        expect(current_path).to eq root_path
        expect(page).to have_content 'ログアウトしました。'
      end

      scenario "ユーザー削除", js: true do
        visit user_path(user.id)
        click_on '編集する'
        visit edit_user_registration_path
        click_on 'アカウント削除'
        expect do
          expect(page.accept_confirm).to eq '本当に良いですか?'
          expect(page).to have_content 'アカウントを削除しました。またのご利用をお待ちしております。'
        end.to change { User.count }.by(-1)
        expect(current_path).to eq root_path
      end

      scenario "初期設定のアカウント画像が表示されているか" do
        expect(page).to have_selector("img[src$='no_image.jpg']")
      end
    end

    context "ユーザー編集" do
      before do
        login(user)
        visit user_path(user.id)
        click_on '編集する'
        visit edit_user_registration_path
      end

      scenario "フォームの値が正常" do
        fill_in('user_username', with: 'クロ')
        attach_file('user_image', "#{Rails.root}/spec/fixtures/aurora.jpg")
        select('英国', from: 'user_country_code')
        fill_in('user_job', with: 'カフェ')
        fill_in('user_email', with: 'kurokuro@test.com')
        fill_in('user_password', with: 'password')
        fill_in('user_password_confirmation', with: 'password')
        click_button("更新")
        expect(current_path).to eq user_path(user.id)
        expect(page).to have_content 'アカウント情報を変更しました。'
        expect(page).to have_content 'クロ'
        expect(page).to have_selector("img[src$='aurora.jpg']")
        expect(page).to have_content '英国'
        expect(page).to have_content 'カフェ'
        expect(page).to have_content 'kurokuro@test.com'
      end

      scenario "ユーザー名未入力" do
        fill_in('user_username', with: '')
        attach_file('user_image', "#{Rails.root}/spec/fixtures/aurora.jpg")
        select('英国', from: 'user_country_code')
        fill_in('user_job', with: 'カフェ')
        fill_in('user_email', with: 'kurokuro@test.com')
        fill_in('user_password', with: 'password')
        fill_in('user_password_confirmation', with: 'password')
        click_button("更新")
        expect(page).to have_content 'ユーザー名を入力してください'
      end

      scenario "メールアドレス未入力" do
        fill_in('user_username', with: 'クロ')
        attach_file('user_image', "#{Rails.root}/spec/fixtures/aurora.jpg")
        select('英国', from: 'user_country_code')
        fill_in('user_job', with: 'カフェ')
        fill_in('user_email', with: '')
        fill_in('user_password', with: 'password')
        fill_in('user_password_confirmation', with: 'password')
        click_button("更新")
        expect(page).to have_content 'メールアドレスを入力してください'
      end

      scenario "国名未入力" do
        fill_in('user_username', with: 'クロ')
        attach_file('user_image', "#{Rails.root}/spec/fixtures/aurora.jpg")
        select('国を選択', from: 'user_country_code')
        fill_in('user_job', with: 'カフェ')
        fill_in('user_email', with: 'kurokuro@test.com')
        fill_in('user_password', with: 'password')
        fill_in('user_password_confirmation', with: 'password')
        click_button("更新")
        expect(page).to have_content '国を入力してください'
      end

      scenario "確認用パスワードが不一致" do
        fill_in('user_username', with: 'クロ')
        attach_file('user_image', "#{Rails.root}/spec/fixtures/aurora.jpg")
        select('英国', from: 'user_country_code')
        fill_in('user_job', with: 'カフェ')
        fill_in('user_email', with: 'kurokuro@test.com')
        fill_in('user_password', with: 'password')
        fill_in('user_password_confirmation', with: 'secret')
        click_button("更新")
        expect(page).to have_content '確認用パスワードとパスワードの入力が一致しません'
      end

      scenario "仕事未入力" do
        fill_in('user_username', with: 'クロ')
        attach_file('user_image', "#{Rails.root}/spec/fixtures/aurora.jpg")
        select('英国', from: 'user_country_code')
        fill_in('user_job', with: 'カフェ')
        fill_in('user_email', with: 'kurokuro@test.com')
        fill_in('user_password', with: 'password')
        fill_in('user_password_confirmation', with: 'password')
        click_button("更新")
        expect(current_path).to eq user_path(user.id)
        expect(page).to have_content ''
      end

      scenario "パスワードが未入力" do
        fill_in('user_username', with: 'クロ')
        attach_file('user_image', "#{Rails.root}/spec/fixtures/aurora.jpg")
        select('英国', from: 'user_country_code')
        fill_in('user_job', with: 'カフェ')
        fill_in('user_email', with: 'kurokuro@test.com')
        fill_in('user_password', with: nil)
        fill_in('user_password_confirmation', with: nil)
        click_button("更新")
        expect(current_path).to eq user_path(user.id)
        expect(page).to have_content 'アカウント情報を変更しました。'
      end
    end

    context "アカウント" do
      before do
        login(user)
        visit root_path
      end

      scenario "アカウントの文字が表示されている" do
        find(".dropdown-toggle").click
        expect(page).to have_content 'アカウント'
      end

      scenario "アカウントページリンクされているか" do
        find(".dropdown-toggle").click
        expect(page).to have_content 'アカウント'
        click_on 'アカウント'
        expect(current_path).to eq user_path(user.id)
      end

      scenario "ユーザーの情報がアカウントページに表示されているか" do
        find(".dropdown-toggle").click
        expect(page).to have_content 'アカウント'
        click_on 'アカウント'
        visit user_path(user.id)
        expect(page).to have_content user.username
        expect(page).to have_content user.country_name
        expect(page).to have_content user.email
        expect(page).to have_content user.job
        expect(page).to have_content '*********'
        expect(page).to have_selector("img[src$='no_image.jpg']")
      end
    end
  end
end
