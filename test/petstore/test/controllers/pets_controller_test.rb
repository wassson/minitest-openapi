require "test_helper"

class PetsControllerTest < ActionDispatch::IntegrationTest
  document!

  setup do
    @pet = pets(:one)
  end

  test "should get index" do
    get pets_url, as: :json
    assert_response :success
  end

  test "should create pet" do
    assert_difference("Pet.count") do
      post pets_url, params: { pet: { name: @pet.name } }, as: :json
    end

    assert_response :created
  end

  test "should not create pet with empty name" do
    assert_no_difference("Pet.count") do
      post pets_url, params: { pet: { name: "" } }, as: :json
    end

    assert_response :unprocessable_entity # or the specific error code your API returns
    assert_includes @response.body, "error" # check if the response body contains 'error'
  end

  test "should show pet" do
    get pet_url(@pet), as: :json
    assert_response :success
  end

  test "should update pet" do
    patch pet_url(@pet), params: { pet: { name: @pet.name } }, as: :json
    assert_response :success
  end

  test "should destroy pet" do
    assert_difference("Pet.count", -1) do
      delete pet_url(@pet), as: :json
    end

    assert_response :no_content
  end
end
