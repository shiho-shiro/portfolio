require "test_helper"

class RecommendsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @recommend = recommends(:one)
  end

  test "should get index" do
    get recommends_url
    assert_response :success
  end

  test "should get new" do
    get new_recommend_url
    assert_response :success
  end

  test "should create recommend" do
    assert_difference('Recommend.count') do
      post recommends_url, params: { recommend: { address: @recommend.address, content: @recommend.content, country_code: @recommend.country_code, image: @recommend.image, latitude: @recommend.latitude, longitude: @recommend.longitude, title: @recommend.title, user_id: @recommend.user_id } }
    end

    assert_redirected_to recommend_url(Recommend.last)
  end

  test "should show recommend" do
    get recommend_url(@recommend)
    assert_response :success
  end

  test "should get edit" do
    get edit_recommend_url(@recommend)
    assert_response :success
  end

  test "should update recommend" do
    patch recommend_url(@recommend), params: { recommend: { address: @recommend.address, content: @recommend.content, country_code: @recommend.country_code, image: @recommend.image, latitude: @recommend.latitude, longitude: @recommend.longitude, title: @recommend.title, user_id: @recommend.user_id } }
    assert_redirected_to recommend_url(@recommend)
  end

  test "should destroy recommend" do
    assert_difference('Recommend.count', -1) do
      delete recommend_url(@recommend)
    end

    assert_redirected_to recommends_url
  end
end
