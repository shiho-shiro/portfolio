require "rails_helper"

RSpec.describe HomeController, type: :controller do
  describe "#top" do
    it "正常にレスポンスを返すこと" do
      get :top
      expect(response).to be_successful
    end

    it "200レスポンスを返すこと" do
      get :top
      expect(response).to have_http_status "200"
    end
  end
end
