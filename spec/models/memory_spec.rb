require 'rails_helper'

RSpec.describe Memory, type: :model do
  describe "バリデーション" do
    before do
      @memory = build(:memory)
    end

    it "タイトル、コンテンツ、日付が入力されていれば有効" do
      expect(@memory).to be_valid
    end

    it "タイトルが空欄の場合無効" do
      @memory.title = nil
      @memory.valid?
      expect(@memory.errors[:title]).to include("を入力してください")
    end

    it "コンテンツが空欄の場合無効" do
      @memory.content = nil
      @memory.valid?
      expect(@memory.errors[:content]).to include("を入力してください")
    end

    it "タイトルは20文字以内の場合有効" do
      @memory.title = Faker::Lorem.characters(number: 20)
      expect(@memory).to be_valid
    end

    it "タイトルは20文字以上の場合無効" do
      @memory.title = Faker::Lorem.characters(number: 21)
      @memory.valid?
      expect(@memory.errors[:title]).to include("は20文字以内で入力してください")
    end

    it "コンテンツは300文字以内の場合有効" do
      @memory.content = Faker::Lorem.characters(number: 300)
      expect(@memory).to be_valid
    end

    it "コンテンツは300文字以上の場合無効" do
      @memory.content = Faker::Lorem.characters(number: 301)
      @memory.valid?
      expect(@memory.errors[:content]).to include("は300文字以内で入力してください")
    end

    it "日付は今日より過去の日付の場合無効" do
      @memory.date = Faker::Date.backward(days: 2)
      @memory.valid?
      expect(@memory.errors[:date]).to include("今日より過去の日付の指定はできません。")
    end
  end

  describe "画像" do
    it "画像ファイルが指定されるとアップロードされる" do
      @memory = build(:memory)
      @memory.image = Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/aurora.jpg'))
      expect(@memory).to be_valid
    end
  end
end
