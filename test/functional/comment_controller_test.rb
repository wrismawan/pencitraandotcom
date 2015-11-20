require 'test_helper'

class CommentControllerTest < ActionController::TestCase
  test "should get postcomment" do
    get :postcomment
    assert_response :success
  end

end
