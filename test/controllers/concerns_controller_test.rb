require "test_helper"

class ConcernsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @concern = concerns(:one)
  end

  test "should get index" do
    get concerns_url
    assert_response :success
  end

  test "should get new" do
    get new_concern_url
    assert_response :success
  end

  test "should create concern" do
    assert_difference('Concern.count') do
      post concerns_url, params: { concern: { content: @concern.content, image: @concern.image, title: @concern.title, user_id: @concern.user_id } }
    end

    assert_redirected_to concern_url(Concern.last)
  end

  test "should show concern" do
    get concern_url(@concern)
    assert_response :success
  end

  test "should get edit" do
    get edit_concern_url(@concern)
    assert_response :success
  end

  test "should update concern" do
    patch concern_url(@concern), params: { concern: { content: @concern.content, image: @concern.image, title: @concern.title, user_id: @concern.user_id } }
    assert_redirected_to concern_url(@concern)
  end

  test "should destroy concern" do
    assert_difference('Concern.count', -1) do
      delete concern_url(@concern)
    end

    assert_redirected_to concerns_url
  end
end
