require "application_system_test_case"

class ConcernsTest < ApplicationSystemTestCase
  setup do
    @concern = concerns(:one)
  end

  test "visiting the index" do
    visit concerns_url
    assert_selector "h1", text: "Concerns"
  end

  test "creating a Concern" do
    visit concerns_url
    click_on "New Concern"

    fill_in "Content", with: @concern.content
    fill_in "Image", with: @concern.image
    fill_in "Title", with: @concern.title
    fill_in "User", with: @concern.user_id
    click_on "Create Concern"

    assert_text "Concern was successfully created"
    click_on "Back"
  end

  test "updating a Concern" do
    visit concerns_url
    click_on "Edit", match: :first

    fill_in "Content", with: @concern.content
    fill_in "Image", with: @concern.image
    fill_in "Title", with: @concern.title
    fill_in "User", with: @concern.user_id
    click_on "Update Concern"

    assert_text "Concern was successfully updated"
    click_on "Back"
  end

  test "destroying a Concern" do
    visit concerns_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Concern was successfully destroyed"
  end
end
