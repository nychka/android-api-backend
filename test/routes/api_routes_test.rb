class ApiRoutesTest < ActionController::TestCase
  test "GET /auth" do
    assert_routing '/auth', controller: "auth", action: "index"
  end
  test "PUT /users" do
  	assert_routing({ method: 'put', path: '/users'}, { controller: 'users', action: 'update'})
  end
  test "POST /users" do
  	assert_routing({ method: 'post', path: '/users'}, { controller: 'users', action: 'create'})
  end
  test "GET /users/:id" do
  	assert_routing({ method: 'get', path: '/users/1'}, { controller: 'users', action: 'show', id: "1" })
  end
  test "GET /users/nearby/" do
    assert_routing({ method: 'get', path: '/users/nearby'}, { controller: 'users', action: 'nearby' })
  end
end