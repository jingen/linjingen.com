require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should get avatar" do
    get :avatar
    assert_response :success
  end

end
