class HomeRoutesTest < ActionController::TestCase

  test "must route to home index" do
    assert_routing '/', controller: "profile", action: "index"
  end
  test "must route to auth index" do
    assert_routing '/auth', controller: "auth", action: "index"
  end
end