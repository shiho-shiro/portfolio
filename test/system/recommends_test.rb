require "application_system_test_case"

class RecommendsTest < ApplicationSystemTestCase
  setup do
    @recommend = recommends(:one)
  end

  test "visiting the index" do
    visit recommends_url
    assert_selector "h1", text: "Recommends"
  end

  test "creating a Recommend" do
    visit recommends_url
    click_on "New Recommend"

    fill_in "Address", with: @recommend.address
    fill_in "Content", with: @recommend.content
    fill_in "Country code", with: @recommend.country_code
    fill_in "Image", with: @recommend.image
    fill_in "Latitude", with: @recommend.latitude
    fill_in "Longitude", with: @recommend.longitude
    fill_in "Title", with: @recommend.title
    fill_in "User", with: @recommend.user_id
    click_on "Create Recommend"

    assert_text "Recommend was successfully created"
    click_on "Back"
  end

  test "updating a Recommend" do
    visit recommends_url
    click_on "Edit", match: :first

    fill_in "Address", with: @recommend.address
    fill_in "Content", with: @recommend.content
    fill_in "Country code", with: @recommend.country_code
    fill_in "Image", with: @recommend.image
    fill_in "Latitude", with: @recommend.latitude
    fill_in "Longitude", with: @recommend.longitude
    fill_in "Title", with: @recommend.title
    fill_in "User", with: @recommend.user_id
    click_on "Update Recommend"

    assert_text "Recommend was successfully updated"
    click_on "Back"
  end

  test "destroying a Recommend" do
    visit recommends_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Recommend was successfully destroyed"
  end
end
