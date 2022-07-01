require 'rails_helper'

RSpec.describe Recommend, type: :model do
  describe "バリデーション" do
    before  do
      @recommend = build(:recommend)
    end

    it "タイトル、コンテンツ、国名、アドレスを入力していると有効" do
      expect(@recommend).to be_valid
    end

    it "タイトルが空欄の場合無効" do
      @recommend.title = nil
      @recommend.valid?
      expect(@recommend.errors[:title]).to include("を入力してください")
    end

    it "コンテンツが空欄の場合無効" do
      @recommend.content = nil
      @recommend.valid?
      expect(@recommend.errors[:content]).to include("を入力してください")
    end

    it "国名が選択されていない場合無効" do
      @recommend.country_code = nil
      @recommend.valid?
      expect(@recommend.errors[:country_code]).to include("を入力してください")
    end

    it "アドレスが空欄の場合無効" do
      @recommend.address = nil
      @recommend.valid?
      expect(@recommend.errors[:address]).to include("を入力してください")
    end

    it "タイトルが20文字以内の場合有効" do
      @recommend.title = Faker::Lorem.characters(number: 20)
      expect(@recommend).to be_valid
    end

    it "タイトルが20文字以上の場合無効" do
      @recommend.title =  Faker::Lorem.characters(number: 21)
      @recommend.valid?
      expect(@recommend.errors[:title]).to include("は20文字以内で入力してください")
    end

    it "コンテンツが200文字以内の場合有効" do
      @recommend.content = Faker::Lorem.characters(number: 200)
      expect(@recommend).to be_valid
    end

    it "コンテンツが200文字以上の場合無効" do
      @recommend.content =  Faker::Lorem.characters(number: 201)
      @recommend.valid?
      expect(@recommend.errors[:content]).to include("は200文字以内で入力してください")
    end
  end

  describe "画像" do
    it "画像ファイルが指定されるとアップロードされる" do
      @recommend = create(:recommend)
      @recommend.image = Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/aurora.jpg'))
      expect(@recommend).to be_valid
    end
  end

  describe "アドレス" do
    it "入力したアドレスの経度と緯度が合っているか" do
      @recommend_1 = create(:recommend, address: "東京都千代田区丸の内１丁目９ 東京駅" )
      expect(@recommend_1.latitude).to be_within(0.005).of 35.6811751768504
      expect(@recommend_1.longitude).to be_within(0.005).of 139.76595535452452
    end
  end
end
