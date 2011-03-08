require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  test "should get toggle_registration_availability" do
    get :toggle_registration_availability
    assert_response :success
  end

end
