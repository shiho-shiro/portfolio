require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = build(:user)
  end

  describe 'バリデーション' do
    it "is valid with username, email, password" do
      expect(@user).to be_valid
    end
  end
end
