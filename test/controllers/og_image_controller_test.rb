require "test_helper"

class OgImageControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get og_image_show_url
    assert_response :success
  end
end
