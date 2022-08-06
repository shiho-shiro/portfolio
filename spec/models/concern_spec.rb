require 'rails_helper'

RSpec.describe Concern, type: :model do
  describe "バリデーション" do
    before do
      @concern = build(:concern)
    end

    it "タイトル、コンテンツ、国名を入力していると有効" do
      expect(@concern).to be_valid
    end

    it "タイトルが空欄の場合無効" do
      @concern.title = nil
      @concern.valid?
      expect(@concern.errors[:title]).to include("を入力してください")
    end

    it "コンテンツが空欄の場合無効" do
      @concern.content = nil
      @concern.valid?
      expect(@concern.errors[:content]).to include("を入力してください")
    end

    it "国名が空欄の場合無効" do
      @concern.country_code = nil
      @concern.valid?
      expect(@concern.errors[:country_code]).to include("を入力してください")
    end

    it "タイトルは20文字以内で有効" do
      @concern.title = Faker::Lorem.characters(number: 20)
      expect(@concern).to be_valid
    end

    it "タイトルは20文字以上で無効" do
      @concern.title = Faker::Lorem.characters(number: 21)
      @concern.valid?
      expect(@concern.errors[:title]).to include("は20文字以内で入力してください")
    end

    it "コンテンツは200文字以内で有効" do
      @concern.content = Faker::Lorem.characters(number: 200)
      expect(@concern).to be_valid
    end

    it "コンテンツは200文字以上で無効" do
      @concern.content = Faker::Lorem.characters(number: 201)
      @concern.valid?
      expect(@concern.errors[:content]).to include("は200文字以内で入力してください")
    end
  end

  describe "画像" do
    it "画像ファイルが指定されるとアップロードされる" do
      @concern = create(:concern)
      @concern.image = Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/aurora.jpg'))
      expect(@concern).to be_valid
    end
  end
end
