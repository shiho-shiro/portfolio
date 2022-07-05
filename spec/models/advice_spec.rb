require 'rails_helper'

RSpec.describe Advice, type: :model do
  describe "バリデーション" do
    before do
      @advice = build(:advice)
    end

    it "アドバイスが入力されていれば有効" do
      expect(@advice).to be_valid
    end

    it "アドバイスが空欄の場合無効" do
      @advice.advice = nil
      @advice.valid?
      expect(@advice).not_to be_valid
    end
  end
end
