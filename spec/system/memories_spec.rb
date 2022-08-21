require 'rails_helper'

RSpec.describe "Memories", type: :system do
  let(:user) { create(:user) }
  let(:friend_user) { create(:friend_user) }
  let!(:memory) { create(:memory, user_id: friend_user.id) }
  let!(:memory_1) { create(:memory_2, user_id: user.id) }

  describe "投稿一覧" do
    context "ログイン済みのユーザーとして" do
      before do
        another_login(friend_user)
        visit root_path
        first(".navbar-nav").click_link("Memory")
        visit memories_path
      end

      scenario "memory一覧画面にタイトルと、更新日が表示されている" do
        expect(page).to have_content memory.title
        expect(page).to have_content memory.date
        expect(page).to have_selector("img[src$='no_image.jpg']")
      end

      scenario "タイトルをクリックすると、その投稿の詳細画面へリンクする" do
        click_on(memory.title)
        expect(current_path).to eq memory_path(memory.id)
      end
    end
  end

  describe "Memoryの投稿" do
    before do
      login(user)
      visit new_memory_path
    end

    scenario "フォームの値が正常か" do
      fill_in('タイトル', with: '初めての投稿')
      fill_in('日記', with: 'ついに始まった新しい生活')
      select('2022', from: 'memory_date_1i')
      select('1月', from: 'memory_date_2i')
      select('1', from: 'memory_date_3i')
      attach_file('画像', "#{Rails.root}/spec/fixtures/aurora.jpg")
      click_button 'Memoryを投稿する'
      expect(current_path).to eq memory_path(Memory.last)
      expect(page).to have_content 'Memoryを作成しました'
      expect(page).to have_content '初めての投稿'
      expect(page).to have_content 'ついに始まった新しい生活'
      expect(page).to have_content '2022-01-01'
      expect(page).to have_selector("img[src$='aurora.jpg']")
    end

    scenario "タイトルがnilの場合" do
      fill_in('タイトル', with: nil)
      fill_in('日記', with: 'ついに始まった新しい生活')
      select('2022', from: 'memory_date_1i')
      select('1月', from: 'memory_date_2i')
      select('1', from: 'memory_date_3i')
      attach_file('画像', "#{Rails.root}/spec/fixtures/aurora.jpg")
      click_button 'Memoryを投稿する'
      expect(page).to have_content 'タイトルを入力してください'
    end

    scenario "コンテンツがnilの場合" do
      fill_in('タイトル', with: '初めての投稿')
      fill_in('日記', with: '')
      select('2022', from: 'memory_date_1i')
      select('1月', from: 'memory_date_2i')
      select('1', from: 'memory_date_3i')
      attach_file('画像', "#{Rails.root}/spec/fixtures/aurora.jpg")
      click_button 'Memoryを投稿する'
      expect(page).to have_content '日記を入力してください'
    end

    scenario "タイトルが20文字以上はエラーコメントが表示" do
      fill_in('タイトル', with: Faker::Lorem.characters(number: 21))
      fill_in('日記', with: 'ついに始まった新しい生活')
      select('2022', from: 'memory_date_1i')
      select('1月', from: 'memory_date_2i')
      select('1', from: 'memory_date_3i')
      attach_file('画像', "#{Rails.root}/spec/fixtures/aurora.jpg")
      click_button 'Memoryを投稿する'
      expect(page).to have_content 'タイトルは20文字以内で入力してください'
    end

    scenario "コンテンツが300文字以上はエラーコメントが表示" do
      fill_in('タイトル', with: '初めての投稿')
      fill_in('日記', with: Faker::Lorem.characters(number: 301))
      select('2022', from: 'memory_date_1i')
      select('1月', from: 'memory_date_2i')
      select('1', from: 'memory_date_3i')
      attach_file('画像', "#{Rails.root}/spec/fixtures/aurora.jpg")
      click_button 'Memoryを投稿する'
      expect(page).to have_content '日記は300文字以内で入力してください'
    end
  end

  describe "投稿の詳細画面" do
    before do
      login(user)
      visit memories_path
    end

    scenario "タイトルとコンテンツと画像が表示されているか" do
      click_link memory_1.title
      visit memory_path(memory_1.id)
      expect(page).to have_content memory_1.title
      expect(page).to have_content memory_1.content
      expect(page).to have_selector("img[src$='no_image.jpg']")
    end
  end

  describe "Memoryの編集" do
    before do
      another_login(friend_user)
      visit memories_path
      click_link memory.title
      visit memory_path(memory.id)
    end

    scenario "タイトルをクリックすると編集する・戻る・削除するの文字が表示される" do
      find(".btn-outline-info.dropdown-toggle").click
      expect(page).to have_content '編集する'
      expect(page).to have_content '戻る'
      expect(page).to have_button '削除する'
    end

    scenario "投稿詳細へ戻るボタンがあるか" do
      visit edit_memory_path(memory.id)
      expect(page).to have_content 'この投稿を見る'
    end

    scenario "投稿詳細へ戻るボタンのパスはあっているか" do
      visit edit_memory_path(memory.id)
      click_link 'この投稿を見る'
      expect(current_path).to eq memory_path(memory.id)
    end

    scenario "フォームの値が正常か" do
      visit edit_memory_path(memory.id)
      fill_in('タイトル', with: 'memoryの編集後')
      fill_in('日記', with: '編集されました。')
      select('2022', from: 'memory_date_1i')
      select('4月', from: 'memory_date_2i')
      select('6', from: 'memory_date_3i')
      attach_file('画像', "#{Rails.root}/spec/fixtures/aurora.jpg")
      click_button 'Memoryを投稿する'
      expect(current_path).to eq memory_path(memory.id)
      expect(page).to have_content 'Memoryを更新しました。'
      expect(page).to have_content 'memoryの編集後'
      expect(page).to have_content '編集されました'
      expect(page).to have_content '2022-04-06'
      expect(page).to have_selector("img[src$='aurora.jpg']")
    end

    scenario "画像のみ削除できるか" do
      visit edit_memory_path(memory.id)
      check 'memory_remove_image'
      click_button 'Memoryを投稿する'
      expect(page).not_to have_selector("img[src$='no_image.jpg']")
    end

    scenario "タイトルがnilの場合" do
      visit edit_memory_path(memory.id)
      fill_in('タイトル', with: nil)
      fill_in('日記', with: '編集されました。')
      select('2022', from: 'memory_date_1i')
      select('4月', from: 'memory_date_2i')
      select('6', from: 'memory_date_3i')
      attach_file('画像', "#{Rails.root}/spec/fixtures/aurora.jpg")
      click_button 'Memoryを投稿する'
      expect(page).to have_content 'タイトルを入力してください'
    end

    scenario "コンテンツがnilの場合" do
      visit edit_memory_path(memory.id)
      fill_in('タイトル', with: 'memoryの編集後')
      fill_in('日記', with: nil)
      select('2022', from: 'memory_date_1i')
      select('4月', from: 'memory_date_2i')
      select('6', from: 'memory_date_3i')
      attach_file('画像', "#{Rails.root}/spec/fixtures/aurora.jpg")
      click_button 'Memoryを投稿する'
      expect(page).to have_content '日記を入力してください'
    end

    scenario "タイトルが20文字以上はエラーコメントが表示" do
      visit edit_memory_path(memory.id)
      fill_in('タイトル', with: Faker::Lorem.characters(number: 21))
      fill_in('日記', with: '編集されました。')
      select('2022', from: 'memory_date_1i')
      select('4月', from: 'memory_date_2i')
      select('6', from: 'memory_date_3i')
      attach_file('画像', "#{Rails.root}/spec/fixtures/aurora.jpg")
      click_button 'Memoryを投稿する'
      expect(page).to have_content 'タイトルは20文字以内で入力してください'
    end

    scenario "コンテンツが300文字以上はエラーコメントが表示" do
      visit edit_memory_path(memory.id)
      fill_in('タイトル', with: 'memoryの編集後')
      fill_in('日記', with: Faker::Lorem.characters(number: 301))
      select('2022', from: 'memory_date_1i')
      select('4月', from: 'memory_date_2i')
      select('6', from: 'memory_date_3i')
      attach_file('画像', "#{Rails.root}/spec/fixtures/aurora.jpg")
      click_button 'Memoryを投稿する'
      expect(page).to have_content '日記は300文字以内で入力してください'
    end
  end

  describe "Memoryの削除" do
    before do
      login(user)
      visit memories_path
      click_link memory_1.title
      visit memory_path(memory_1.id)
    end

    scenario "投稿を削除できる" do
      find(".btn-outline-info.dropdown-toggle").click
      click_button '削除する'
      expect(current_path).to eq memories_path
      expect(page).to have_content 'Memoryを削除しました。'
    end
  end
end
