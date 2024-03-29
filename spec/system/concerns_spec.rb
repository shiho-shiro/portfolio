require 'rails_helper'

RSpec.describe "Concerns", type: :system do
  let(:user) { create(:user) }
  let!(:friend_user) { create(:friend_user) }
  let!(:concern_1) { create(:concern, user_id: friend_user.id) }
  let!(:concern_2) { create(:concern_1, user_id: user.id) }
  let!(:concern_3) { create(:concern_2, user_id: user.id) }
  let!(:advice_1) { create(:advice, concern_id: concern_1.id, user_id: user.id) }
  let!(:advice_2) { create(:advice, concern_id: concern_2.id, user_id: friend_user.id) }

  describe "投稿一覧" do
    before do
      login(user)
      visit root_path
      within '.navbar-nav' do
        click_link 'お悩み相談'
      end
      visit concerns_path
    end

    scenario "タイトル、更新日、アカウント画像が表示される" do
      expect(page).to have_content concern_1.title
      expect(page).to have_content concern_1.created_at.to_s(:datetime_jp)
      expect(page).to have_selector("img[src$='cake.jpg']")
      expect(page).to have_content concern_2.title
      expect(page).to have_content concern_2.created_at.to_s(:datetime_jp)
      expect(page).to have_selector("img[src$='no_image.jpg']")
    end

    scenario "投稿画像が表示されている" do
      expect(page).to have_content concern_3.title
      expect(page).to have_content concern_3.created_at.to_s(:datetime_jp)
      expect(page).to have_selector("img[src$='aurora.jpg']")
    end

    scenario "タイトルをクリックすると、その投稿の詳細画面へリンクする" do
      click_on(concern_2.title)
      expect(current_path).to eq concern_path(concern_2.id)
    end
  end

  describe "concernの投稿" do
    before do
      login(user)
      visit new_concern_path
    end

    scenario "フォームの値が正常か" do
      fill_in('タイトル', with: 'シェアハウスについて')
      fill_in('相談内容', with: 'ダウンタウンの相場はどのくらいなのでしょうか？')
      select('カナダ', from: 'concern_country_code')
      attach_file('画像', "#{Rails.root}/spec/fixtures/no_image.jpg")
      click_button 'お悩みを相談する'
      expect(current_path).to eq concern_path(Concern.last)
      expect(page).to have_content 'お悩みを投稿しました。'
      expect(page).to have_content 'シェアハウスについて'
      expect(page).to have_content 'ダウンタウンの相場はどのくらいなのでしょうか？'
      expect(page).to have_content 'カナダ'
      expect(page).to have_selector("img[src$='no_image.jpg']")
    end

    scenario "タイトルがnilの場合" do
      fill_in('タイトル', with: nil)
      fill_in('相談内容', with: 'ダウンタウンの相場はどのくらいなのでしょうか？')
      select('カナダ', from: 'concern_country_code')
      attach_file('画像', "#{Rails.root}/spec/fixtures/no_image.jpg")
      click_button 'お悩みを相談する'
      expect(page).to have_content 'タイトルを入力してください'
    end

    scenario "相談内容がnilの場合" do
      fill_in('タイトル', with: 'シェアハウスについて')
      fill_in('相談内容', with: nil)
      select('カナダ', from: 'concern_country_code')
      attach_file('画像', "#{Rails.root}/spec/fixtures/no_image.jpg")
      click_button 'お悩みを相談する'
      expect(page).to have_content '相談内容を入力してください'
    end

    scenario "国名がnilの場合" do
      fill_in('タイトル', with: 'シェアハウスについて')
      fill_in('相談内容', with: 'ダウンタウンの相場はどのくらいなのでしょうか？')
      select('国を選択', from: 'concern_country_code')
      attach_file('画像', "#{Rails.root}/spec/fixtures/no_image.jpg")
      click_button 'お悩みを相談する'
      expect(page).to have_content '対象国を入力してください'
    end

    scenario "タイトルが20文字以上はエラーコメントが表示" do
      fill_in('タイトル', with: Faker::Lorem.characters(number: 21))
      fill_in('相談内容', with: 'ダウンタウンの相場はどのくらいなのでしょうか？')
      select('カナダ', from: 'concern_country_code')
      attach_file('画像', "#{Rails.root}/spec/fixtures/no_image.jpg")
      click_button 'お悩みを相談する'
      expect(page).to have_content 'タイトルは20文字以内で入力してください'
    end

    scenario "コンテンツが200文字以上はエラーコメントが表示" do
      fill_in('タイトル', with: 'シェアハウスについて')
      fill_in('相談内容', with: Faker::Lorem.characters(number: 201))
      select('カナダ', from: 'concern_country_code')
      attach_file('画像', "#{Rails.root}/spec/fixtures/no_image.jpg")
      click_button 'お悩みを相談する'
      expect(page).to have_content '相談内容は200文字以内で入力してください'
    end
  end

  describe "投稿の詳細画面" do
    before do
      login(user)
      visit concerns_path
    end

    scenario "タイトルとコンテンツと画像が表示されているか" do
      click_link concern_1.title
      visit concern_path(concern_1.id)
      expect(page).to have_content concern_1.title
      expect(page).to have_content concern_1.content
      expect(page).to have_content concern_1.user.username
      expect(page).to have_content concern_1.country_name
      expect(page).to have_selector("img[src$='cake.jpg']")
    end

    scenario "投稿者の情報表示" do
      click_link concern_1.title
      visit concern_path(concern_1.id)
      click_link 'show_concern_img'
      expect(current_path).to eq show_other_user_path(friend_user.id)
    end
  end

  describe "concernの編集" do
    before do
      another_login(friend_user)
      visit concerns_path
      click_link concern_1.title
      visit concern_path(concern_1.id)
    end

    scenario "タイトルをクリックすると編集する・戻る・削除するの文字が表示される" do
      find(".concern_dropdown").click
      expect(page).to have_content '編集する'
      expect(page).to have_content '戻る'
      expect(page).to have_button '削除する'
    end

    scenario "投稿詳細へ戻るボタンがあるか" do
      visit edit_concern_path(concern_1.id)
      expect(page).to have_content 'この投稿を見る'
    end

    scenario "投稿詳細へ戻るボタンのパスはあっているか" do
      visit edit_concern_path(concern_1.id)
      click_link 'この投稿を見る'
      expect(current_path).to eq concern_path(concern_1.id)
    end

    scenario "フォームの値が正常か" do
      visit edit_concern_path(concern_1.id)
      fill_in('タイトル', with: 'お金について')
      fill_in('相談内容', with: 'どこで換金しますか？')
      select('アイルランド', from: 'concern_country_code')
      click_button 'お悩みを相談する'
      expect(current_path).to eq concern_path(concern_1.id)
      expect(page).to have_content '投稿内容が変更されました。'
      expect(page).to have_content 'お金について'
      expect(page).to have_content 'どこで換金しますか？'
      expect(page).to have_content 'アイルランド'
    end

    scenario "画像のみ削除できるか" do
      visit edit_concern_path(concern_1.id)
      check 'concern_remove_image'
      click_button 'お悩みを相談する'
      expect(page).not_to have_selector("img[src$='no_image.jpg']")
    end

    scenario "タイトルがnilの場合" do
      visit edit_concern_path(concern_1.id)
      fill_in('タイトル', with: nil)
      fill_in('相談内容', with: 'どこで換金しますか？')
      select('アイルランド', from: 'concern_country_code')
      click_button 'お悩みを相談する'
      expect(page).to have_content 'タイトルを入力してください'
    end

    scenario "相談内容がnilの場合" do
      visit edit_concern_path(concern_1.id)
      fill_in('タイトル', with: 'お金について')
      fill_in('相談内容', with: nil)
      select('アイルランド', from: 'concern_country_code')
      click_button 'お悩みを相談する'
      expect(page).to have_content '相談内容を入力してください'
    end

    scenario "国名がnilの場合" do
      visit edit_concern_path(concern_1.id)
      fill_in('タイトル', with: 'お金について')
      fill_in('相談内容', with: 'どこで換金しますか？')
      select('国を選択', from: 'concern_country_code')
      click_button 'お悩みを相談する'
      expect(page).to have_content '対象国を入力してください'
    end

    scenario "タイトルが20文字以上はエラーコメントが表示" do
      visit edit_concern_path(concern_1.id)
      fill_in('タイトル', with: Faker::Lorem.characters(number: 21))
      fill_in('相談内容', with: 'どこで換金しますか？')
      select('アイルランド', from: 'concern_country_code')
      click_button 'お悩みを相談する'
      expect(page).to have_content 'タイトルは20文字以内で入力してください'
    end

    scenario "コンテンツが200文字以上はエラーコメントが表示" do
      visit edit_concern_path(concern_1.id)
      fill_in('タイトル', with: 'お金について')
      fill_in('相談内容', with:  Faker::Lorem.characters(number: 201))
      select('アイルランド', from: 'concern_country_code')
      click_button 'お悩みを相談する'
      expect(page).to have_content '相談内容は200文字以内で入力してください'
    end
  end

  describe "concernの削除" do
    context "メインユーザーが投稿した場合" do
      before do
        another_login(friend_user)
        visit concerns_path
        click_link concern_1.title
        visit concern_path(concern_1.id)
      end

      scenario "投稿を削除できる" do
        find(".concern_dropdown").click
        click_button '削除する'
        expect(current_path).to eq concerns_path
        expect(page).to have_content '投稿が削除されました。'
      end
    end

    context "他のユーザーの投稿の場合" do
      before do
        another_login(friend_user)
        visit concerns_path
        click_link concern_2.title
        visit concern_path(concern_2.id)
      end

      scenario "編集する・削除するのボタンが表示されない" do
        find('.concern_dropdown').click
        expect(page).not_to have_button '削除する'
        expect(page).not_to have_link '編集する'
      end
    end
  end

  describe "アドバイス" do
    before do
      login(user)
      visit concerns_path
      click_link concern_1.title
      visit concern_path(concern_1.id)
    end

    scenario "アドバイスができる" do
      fill_in('advice_advice', with: '空港の換金所がオススメ')
      click_button 'アドバイスを送る'
      expect(page).to have_content '空港の換金所がオススメ'
    end

    scenario "100文字以上だとアドバイスできない" do
      fill_in('advice_advice', with: Faker::Lorem.characters(number: 101))
      click_button 'アドバイスを送る'
      expect(page).to have_content 'アドバイスが出来ませんでした。'
    end

    scenario 'アドバイスしたアカウントの名前と画像が表示される' do
      fill_in('advice_advice', with: '空港の換金所がオススメ')
      click_button 'アドバイスを送る'
      expect(page).to have_content(advice_1.user.username)
      expect(page).to have_selector("img[src$='cake.jpg']")
    end

    scenario "アドバイスした投稿者の場合自分のアドバイスを削除できる" do
      click_on advice_1.user.username
      click_button 'アドバイスを削除'
      expect(page).to have_content 'アドバイスを削除しました。'
    end
  end

  describe "検索" do
    before do
      another_login(friend_user)
      visit concerns_path
    end

    scenario "タイトル名が含まれている場合" do
      fill_in('q_title_cont', with: 'ど')
      click_button 'お悩み検索'
      expect(page).not_to have_content concern_1.title
      expect(page).to have_content concern_2.title
      expect(page).not_to have_selector("img[src$='aurora.jpg']")
    end

    scenario "タイトル名が空欄の場合" do
      fill_in('q_title_cont', with: nil)
      click_button 'お悩み検索'
      expect(page).to have_content concern_1.title
      expect(page).to have_content concern_2.title
      expect(page).to have_selector("img[src$='aurora.jpg']")
    end

    scenario "国名が含まれている場合" do
      select('日本', from: 'q_country_code_cont')
      click_button 'お悩み検索'
      expect(page).not_to have_content concern_1.title
      expect(page).to have_content concern_2.title
      expect(page).to have_selector("img[src$='aurora.jpg']")
    end

    scenario "国名が空欄の場合" do
      select('国を指定する', from: 'q_country_code_cont')
      click_button 'お悩み検索'
      expect(page).to have_content concern_1.title
      expect(page).to have_content concern_2.title
      expect(page).to have_selector("img[src$='aurora.jpg']")
    end
  end

  describe "アドバイス後、アドバイスされた側に通知が行く" do
    before do
      login(user)
      visit concerns_path
      click_link concern_1.title
      visit concern_path(concern_1.id)
      fill_in('advice_advice', with: '空港の換金所がオススメ')
      click_button 'アドバイスを送る'
      within '.navbar-nav' do
        find(".dropdown-toggle").click
        click_on 'ログアウト'
      end
      another_login(friend_user)
    end

    scenario "黄色い丸が表示される" do
      expect(page).to have_css 'i.fa.fa-circle'
    end

    scenario "通知をクリックすると黄色い丸が消える" do
      within '.navbar-nav' do
        click_link '通知'
      end
      expect(page).not_to have_css 'i.fa.fa-circle'
    end

    scenario "通知画面に通知が表示されている" do
      visit notifications_path
      expect(page).to have_content "#{advice_1.user.username}が#{advice_1.concern.title}にコメントしました"
    end

    scenario "アドバイス内容が表示される" do
      visit notifications_path
      expect(page).to have_content '空港の換金所がオススメ'
    end

    scenario "アドバイスしたユーザーのリンク先はあっているか" do
      visit notifications_path
      click_on(advice_1.user.username)
      expect(current_path).to eq show_other_user_path(user.id)
    end

    scenario "悩みのタイトルのリンク先はあっているか" do
      visit notifications_path
      click_on(advice_1.concern.title)
      expect(current_path).to eq concern_path(advice_1.concern.id)
    end

    scenario "通知が削除できる" do
      visit notifications_path
      click_link '通知削除'
      expect(page).to have_content '通知はありません'
    end
  end
end
