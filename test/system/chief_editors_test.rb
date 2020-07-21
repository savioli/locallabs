require "application_system_test_case"

class ChiefEditorsTest < ApplicationSystemTestCase
  setup do
    @chief_editor = chief_editors(:one)
  end

  test "visiting the index" do
    visit chief_editors_url
    assert_selector "h1", text: "Chief Editors"
  end

  test "creating a Chief editor" do
    visit chief_editors_url
    click_on "New Chief Editor"

    fill_in "Email", with: @chief_editor.email
    fill_in "Name", with: @chief_editor.name
    fill_in "Organization", with: @chief_editor.organization_id
    fill_in "Password", with: 'secret'
    fill_in "Password confirmation", with: 'secret'
    fill_in "Type", with: @chief_editor.type
    click_on "Create Chief editor"

    assert_text "Chief editor was successfully created"
    click_on "Back"
  end

  test "updating a Chief editor" do
    visit chief_editors_url
    click_on "Edit", match: :first

    fill_in "Email", with: @chief_editor.email
    fill_in "Name", with: @chief_editor.name
    fill_in "Organization", with: @chief_editor.organization_id
    fill_in "Password", with: 'secret'
    fill_in "Password confirmation", with: 'secret'
    fill_in "Type", with: @chief_editor.type
    click_on "Update Chief editor"

    assert_text "Chief editor was successfully updated"
    click_on "Back"
  end

  test "destroying a Chief editor" do
    visit chief_editors_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Chief editor was successfully destroyed"
  end
end
