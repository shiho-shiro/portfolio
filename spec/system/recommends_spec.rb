require 'rails_helper'

RSpec.describe "Recommends", type: :system do
  let(:user) { create(:user) }
  let!(:friend_user) { create(:friend_user) }
  let!(:recommend_1) { create(:recommend, user_id: friend_user.id) }
  let!(:recommend_2) { create(:another_recommend, user_id: user.id) }
  let!(:like_1) { create(:like, recommend_id: recommend_1.id, user_id: user.id) }
  let!(:like_2) { create(:like, recommend_id: recommend_2.id, user_id: friend_user.id) }

  describe "投稿一覧" do
    before do
      login(user)
      visit root_path
      within '.navbar-nav' do
        click_link 'オススメ'
      end
      visit recommends_path
    end

    scenario "タイトル、更新日、アカウント画像が表示される" do
      expect(page).to have_content recommend_1.title
      expect(page).to have_content recommend_1.created_at.to_s(:datetime_jp)
      expect(page).to have_selector("img[src$='cake.jpg']")
      expect(page).to have_content recommend_2.title
      expect(page).to have_content recommend_2.created_at.to_s(:datetime_jp)
      expect(page).to have_selector("img[src$='no_image.jpg']")
    end

    scenario "いいねの数が表示される" do
      expect(recommend_1.likes.count).to eq(1)
    end

    scenario "タイトルをクリックすると、その投稿の詳細画面へリンクする" do
      click_on(recommend_1.title)
      expect(current_path).to eq recommend_path(recommend_1.id)
    end
  end

  describe "オススメの投稿" do
    before do
      login(user)
      visit new_recommend_path
    end

    scenario "フォームの値が正常か", js: true do
      fill_in('タイトル', with: 'アメリカで美味しいケーキ屋さん')
      fill_in('オススメ内容', with: 'ここのケーキ屋さんは種類が豊富で、お値段がそこまで高くない！')
      select('米国', from: 'recommend_country_code')
      fill_in('住所', with: 'シアトル')
      attach_file('画像', "#{Rails.root}/spec/fixtures/cake.jpg")
      click_button 'オススメを投稿する'
      expect(current_path).to eq recommend_path(Recommend.last)
      expect(page).to have_content 'オススメを投稿しました。'
      expect(page).to have_content 'アメリカで美味しいケーキ屋さん'
      expect(page).to have_content 'ここのケーキ屋さんは種類が豊富で、お値段がそこまで高くない！'
      expect(page).to have_css '.gm-style '
      expect(page).to have_selector("img[src$='cake.jpg']")
    end

    scenario "タイトルがnilの場合" do
      fill_in('タイトル', with: nil)
      fill_in('オススメ内容', with: 'ここのケーキ屋さんは種類が豊富で、お値段がそこまで高くない！')
      select('米国', from: 'recommend_country_code')
      fill_in('住所', with: 'シアトル')
      click_button 'オススメを投稿する'
      expect(page).to have_content 'タイトルを入力してください'
    end

    scenario "オススメ内容がnilの場合" do
      fill_in('タイトル', with: 'アメリカで美味しいケーキ屋さん')
      fill_in('オススメ内容', with: nil)
      select('米国', from: 'recommend_country_code')
      fill_in('住所', with: 'シアトル')
      click_button 'オススメを投稿する'
      expect(page).to have_content 'オススメ内容を入力してください'
    end

    scenario "国名がnilの場合" do
      fill_in('タイトル', with: 'アメリカで美味しいケーキ屋さん')
      fill_in('オススメ内容', with: 'ここのケーキ屋さんは種類が豊富で、お値段がそこまで高くない！')
      select('国を選択', from: 'recommend_country_code')
      fill_in('住所', with: 'シアトル')
      click_button 'オススメを投稿する'
      expect(page).to have_content '対象国を入力してください'
    end

    scenario "住所がnilの場合" do
      fill_in('タイトル', with: nil)
      fill_in('オススメ内容', with: 'ここのケーキ屋さんは種類が豊富で、お値段がそこまで高くない！')
      select('米国', from: 'recommend_country_code')
      fill_in('住所', with: nil)
      click_button 'オススメを投稿する'
      expect(page).to have_content '住所を入力してください'
    end

    scenario "タイトルが20文字以上はエラーコメントが表示" do
      fill_in('タイトル', with: Faker::Lorem.characters(number: 21))
      fill_in('オススメ内容', with: 'ここのケーキ屋さんは種類が豊富で、お値段がそこまで高くない！')
      select('米国', from: 'recommend_country_code')
      fill_in('住所', with: 'シアトル')
      click_button 'オススメを投稿する'
      expect(page).to have_content 'タイトルは20文字以内で入力してください'
    end

    scenario "コンテンツが200文字以上はエラーコメントが表示" do
      fill_in('タイトル', with: 'アメリカで美味しいケーキ屋さん')
      fill_in('オススメ内容', with: Faker::Lorem.characters(number: 201))
      select('米国', from: 'recommend_country_code')
      fill_in('住所', with: 'シアトル')
      click_button 'オススメを投稿する'
      expect(page).to have_content 'オススメ内容は200文字以内で入力してください'
    end
  end

  describe "投稿の詳細画面" do
    before do
      another_login(friend_user)
      visit recommends_path
    end

    scenario "タイトルとコンテンツと画像が表示されているか" do
      click_link recommend_1.title
      visit recommend_path(recommend_1.id)
      expect(page).to have_content recommend_1.title
      expect(page).to have_content recommend_1.content
      expect(page).to have_content recommend_1.user.username
      expect(page).to have_content recommend_1.country_name
      expect(page).to have_selector("img[src$='cake.jpg']")
    end

    scenario "投稿者の情報表示" do
      click_link recommend_2.title
      visit recommend_path(recommend_2.id)
      click_link 'show_recommend_img'
      expect(current_path).to eq show_other_user_path(user.id)
    end
  end

  describe "オススメの編集" do
    before do
      login(user)
      visit(recommends_path)
      click_link recommend_2.title
      visit edit_recommend_path(recommend_2.id)
    end

    scenario "フォームの値が正常か", js: true do
      fill_in('タイトル', with: 'オーロラ')
      fill_in('オススメ内容', with: '人生で一度は見たいオーロラ！カナダがオススメ！')
      select('カナダ', from: 'recommend_country_code')
      fill_in('住所', with: 'イエローナイフ')
      attach_file('画像', "#{Rails.root}/spec/fixtures/aurora.jpg")
      click_button 'オススメを投稿する'
      expect(current_path).to eq recommend_path(recommend_2.id)
      expect(page).to have_content 'オススメを更新しました。'
      expect(page).to have_content 'オーロラ'
      expect(page).to have_content '人生で一度は見たいオーロラ！カナダがオススメ！'
      expect(page).to have_content 'カナダ'
      expect(page).to have_css '.gm-style '
      expect(page).to have_selector("img[src$='aurora.jpg']")
    end

    scenario "タイトルがnilの場合" do
      fill_in('タイトル', with: nil)
      fill_in('オススメ内容', with: '人生で一度は見たいオーロラ！カナダがオススメ！')
      select('カナダ', from: 'recommend_country_code')
      fill_in('住所', with: 'イエローナイフ')
      click_button 'オススメを投稿する'
      expect(page).to have_content 'タイトルを入力してください'
    end

    scenario "オススメ内容がnilの場合" do
      fill_in('タイトル', with: 'オーロラ')
      fill_in('オススメ内容', with: nil)
      select('カナダ', from: 'recommend_country_code')
      fill_in('住所', with: 'イエローナイフ')
      click_button 'オススメを投稿する'
      expect(page).to have_content 'オススメ内容を入力してください'
    end

    scenario "国名がnilの場合" do
      fill_in('タイトル', with: 'オーロラ')
      fill_in('オススメ内容', with: '人生で一度は見たいオーロラ！カナダがオススメ！')
      select('国を選択', from: 'recommend_country_code')
      fill_in('住所', with: 'イエローナイフ')
      click_button 'オススメを投稿する'
      expect(page).to have_content '対象国を入力してください'
    end

    scenario "住所がnilの場合" do
      fill_in('タイトル', with: 'オーロラ')
      fill_in('オススメ内容', with: '人生で一度は見たいオーロラ！カナダがオススメ！')
      select('カナダ', from: 'recommend_country_code')
      fill_in('住所', with: nil)
      click_button 'オススメを投稿する'
      expect(page).to have_content '住所を入力してください'
    end

    scenario "タイトルが20文字以上はエラーコメントが表示" do
      fill_in('タイトル', with: Faker::Lorem.characters(number: 21))
      fill_in('オススメ内容', with: '人生で一度は見たいオーロラ！カナダがオススメ！')
      select('カナダ', from: 'recommend_country_code')
      fill_in('住所', with: 'イエローナイフ')
      click_button 'オススメを投稿する'
      expect(page).to have_content 'タイトルは20文字以内で入力してください'
    end

    scenario "コンテンツが200文字以上はエラーコメントが表示" do
      fill_in('タイトル', with: 'オーロラ')
      fill_in('オススメ内容', with: Faker::Lorem.characters(number: 201))
      select('カナダ', from: 'recommend_country_code')
      fill_in('住所', with: 'イエローナイフ')
      click_button 'オススメを投稿する'
      expect(page).to have_content 'オススメ内容は200文字以内で入力してください'
    end
  end

  describe "オススメの削除" do
    context "メインユーザーが投稿した場合" do
      before do
        login(user)
        visit recommends_path
        click_link recommend_2.title
        visit recommend_path(recommend_2.id)
      end

      scenario "投稿を削除できる" do
        find('.recommend_dropdown').click
        click_button '削除する'
        expect(current_path).to eq recommends_path
        expect(page).to have_content 'オススメを削除しました。'
      end
    end

    context "他のユーザーの投稿の場合" do
      before do
        login(user)
        visit recommends_path
        click_link recommend_1.title
        visit recommend_path(recommend_1.id)
      end

      scenario "編集する・削除するのボタンが表示されない" do
        find('.recommend_dropdown').click
        expect(page).not_to have_button '削除する'
        expect(page).not_to have_link '編集する'
      end
    end
  end

  describe "検索" do
    before do
      login(user)
      visit recommends_path
    end

    scenario "タイトル名が含まれている場合" do
      fill_in('q_title_cont', with: '出来事')
      expect(page).to have_content recommend_2.title
    end

    scenario "タイトル名が空欄の場合" do
      fill_in('q_title_cont', with: nil)
      expect(page).to have_content recommend_1.title
      expect(page).to have_content recommend_2.title
    end

    scenario "国名が含まれている場合" do
      select('日本', from: 'q_country_code_cont')
      expect(page).to have_content recommend_2.title
    end

    scenario "国名が空欄の場合" do
      select('国を指定する', from: 'q_country_code_cont')
      expect(page).to have_content recommend_1.title
      expect(page).to have_content recommend_2.title
    end
  end

  describe "いいねが出来るか" do
    context "メインユーザーが投稿者の場合" do
      before do
        login(user)
        visit recommend_path(recommend_2.id)
      end

      scenario "自分の投稿にいいね出来ない" do
        expect(page).not_to have_link recommend_likes_path(recommend_2.id)
        expect(page).to have_css 'i.fa-solid.fa-heart'
      end
    end

    context "投稿者ではないユーザーの場合" do
      before do
        login(user)
        visit recommend_path(recommend_1.id)
      end

      scenario "他のユーザーの投稿にいいねといいね取り消しが出来る" do
        find('.like_delete').click
        expect(page).to have_css 'i.fa-regular.fa-heart'
        find('.like_post').click
        expect(page).to have_css 'i.fa-solid.fa-heart'
      end
    end
  end

  describe "いいねした後、いいねされたユーザーに通知がいく" do
    before do
      login(user)
      visit recommends_path
      click_link recommend_1.title
      visit recommend_path(recommend_1.id)
    end

    scenario "黄色い丸が表示される" do
      find('.like_delete').click
      expect(page).to have_css 'i.fa-regular.fa-heart'
      find('.like_post').click
      expect(page).to have_css 'i.fa-solid.fa-heart'
      within '.navbar-nav' do
        find(".dropdown-toggle").click
        click_on 'ログアウト'
      end
      another_login(friend_user)
      expect(page).to have_css 'i.fa.fa-circle'
    end

    scenario "通知をクリックすると黄色い丸が消える" do
      find('.like_delete').click
      expect(page).to have_css 'i.fa-regular.fa-heart'
      find('.like_post').click
      expect(page).to have_css 'i.fa-solid.fa-heart'
      within '.navbar-nav' do
        find(".dropdown-toggle").click
        click_on 'ログアウト'
      end
      another_login(friend_user)
      within '.navbar-nav' do
        click_link '通知'
      end
      expect(page).not_to have_css 'i.fa.fa-circle'
    end

    scenario "通知画面に通知が表示されている" do
      find('.like_delete').click
      expect(page).to have_css 'i.fa-regular.fa-heart'
      find('.like_post').click
      expect(page).to have_css 'i.fa-solid.fa-heart'
      within '.navbar-nav' do
        find(".dropdown-toggle").click
        click_on 'ログアウト'
      end
      another_login(friend_user)
      visit notifications_path
      expect(page).to have_content "#{like_1.user.username}があなたの投稿にいいねしました"
    end

    scenario "いいねしたユーザーのリンク先はあっているか" do
      find('.like_delete').click
      expect(page).to have_css 'i.fa-regular.fa-heart'
      find('.like_post').click
      expect(page).to have_css 'i.fa-solid.fa-heart'
      within '.navbar-nav' do
        find(".dropdown-toggle").click
        click_on 'ログアウト'
      end
      another_login(friend_user)
      visit notifications_path
      click_on(like_1.user.username)
      expect(current_path).to eq show_other_user_path(user.id)
    end

    scenario "オススメタイトルのリンク先はあっているか" do
      find('.like_delete').click
      expect(page).to have_css 'i.fa-regular.fa-heart'
      find('.like_post').click
      expect(page).to have_css 'i.fa-solid.fa-heart'
      within '.navbar-nav' do
        find(".dropdown-toggle").click
        click_on 'ログアウト'
      end
      another_login(friend_user)
      visit notifications_path
      click_on 'あなたの投稿'
      expect(current_path).to eq recommend_path(like_1.recommend.id)
    end

    scenario "通知が削除できる" do
      find('.like_delete').click
      expect(page).to have_css 'i.fa-regular.fa-heart'
      find('.like_post').click
      expect(page).to have_css 'i.fa-solid.fa-heart'
      within '.navbar-nav' do
        find(".dropdown-toggle").click
        click_on 'ログアウト'
      end
      another_login(friend_user)
      visit notifications_path
      click_link '通知削除'
      expect(page).to have_content '通知はありません'
    end
  end
end
