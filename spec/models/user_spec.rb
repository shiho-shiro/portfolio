require 'rails_helper'

RSpec.describe User, type: :model do
  describe "バリデーション" do
    before do
      @user = build(:user)
    end

    it "ユーザー名、メールアドレス、パスワードがあれば登録可能" do
      expect(@user).to be_valid
    end

    it "ユーザー名がなければエラーが表示される" do
      @user.username = nil
      @user.valid?
      expect(@user.errors[:username]).to include("を入力してください")
    end

    it "メールアドレスがなければエラーが表示される" do
      @user.email = nil
      @user.valid?
      expect(@user.errors[:email]).to include("を入力してください")
    end

    it "パスワードがなければエラーが表示される" do
      @user.password = nil
      @user.valid?
      expect(@user.errors[:password]).to include("を入力してください")
    end

    it "国名の選択がなければエラーが表示される" do
      @user.country_code = nil
      @user.valid?
      expect(@user.errors[:country_code]).to include("を入力してください")
    end

    it "重複しているメールアドレスはエラーが表示される" do
      @user = create(:user, email: "wonwon@faker.com")
      @user_1 = build(:user, email: "wonwon@faker.com")
      @user_1.valid?
      expect(@user_1.errors[:email]).to include("はすでに存在します")
    end

    it "ユーザー名は10文字以下で有効" do
      @user.username = "0123456789"
      expect(@user).to be_valid
    end

    it "ユーザー名は10文字以上だとエラーが表示される" do
      @user.username = "12345678910"
      @user.valid?
      expect(@user.errors[:username]).to include("は10文字以内で入力してください")
    end

    it "パスワードは6文字以上で有効" do
      @user.password = "123faker"
      @user.password_confirmation = "123faker"
      expect(@user).to be_valid
    end

    it "パスワードは6文字以下だとエラーが表示される" do
      @user.password = "faker"
      @user.password_confirmation = "faker"
      @user.valid?
      expect(@user.errors[:password]).to include("は6文字以上で入力してください")
    end

    it "新規パスワードと確認用パスワードが一致しなければエラーが表示される" do
      @user.password = "fakerrrr"
      @user.password_confirmation = "tureeee"
      @user.valid?
      expect(@user.errors[:password_confirmation]).to include("とパスワードの入力が一致しません")
    end

    it "確認用パスワードが空欄の場合は無効" do
      @user.password = "fakerrrr"
      @user.password_confirmation = ""
      @user.valid?
      expect(@user.errors[:password_confirmation]).to include("とパスワードの入力が一致しません")
    end
  end

  describe "画像" do
    it "画像ファイルが指定されるとアップロードされる" do
      @user = build(:user)
      @user.image = Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/aurora.jpg'))
      expect(@user).to be_valid
    end
  end
end
