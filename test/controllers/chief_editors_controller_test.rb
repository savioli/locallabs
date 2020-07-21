require 'test_helper'

class ChiefEditorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @chief_editor = chief_editors(:one)
  end

  test "should get index" do
    get chief_editors_url
    assert_response :success
  end

  test "should get new" do
    get new_chief_editor_url
    assert_response :success
  end

  test "should create chief_editor" do
    assert_difference('ChiefEditor.count') do
      post chief_editors_url, params: { chief_editor: { email: @chief_editor.email, name: @chief_editor.name, organization_id: @chief_editor.organization_id, password: 'secret', password_confirmation: 'secret', type: @chief_editor.type } }
    end

    assert_redirected_to chief_editor_url(ChiefEditor.last)
  end

  test "should show chief_editor" do
    get chief_editor_url(@chief_editor)
    assert_response :success
  end

  test "should get edit" do
    get edit_chief_editor_url(@chief_editor)
    assert_response :success
  end

  test "should update chief_editor" do
    patch chief_editor_url(@chief_editor), params: { chief_editor: { email: @chief_editor.email, name: @chief_editor.name, organization_id: @chief_editor.organization_id, password: 'secret', password_confirmation: 'secret', type: @chief_editor.type } }
    assert_redirected_to chief_editor_url(@chief_editor)
  end

  test "should destroy chief_editor" do
    assert_difference('ChiefEditor.count', -1) do
      delete chief_editor_url(@chief_editor)
    end

    assert_redirected_to chief_editors_url
  end
end
