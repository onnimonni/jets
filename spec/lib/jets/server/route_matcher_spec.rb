describe Jets::Server::RouteMatcher do
  let(:matcher) { Jets::Server::RouteMatcher.new(env) }

  context "get /" do
    let(:env) do
      { "PATH_INFO" => "/", "REQUEST_METHOD" => "GET" }
    end
    it "find_route finds root route" do
      route = Jets::Route.new(
        path: "/",
        method: :get,
        to: "posts#new",
      )
      found = matcher.route_found?(route)
      expect(found).to be true
    end
  end

  context "get posts/:id/edit" do
    let(:env) do
      { "PATH_INFO" => "/posts/tung/edit", "REQUEST_METHOD" => "GET" }
    end
    it "find_route finds highest precedence route" do
      # In this case the catchall and the capture route matches
      # But the matcher finds the route with the highest precedence
      route = Jets::Route.new(
        path: "*catchall",
        method: :get,
        to: "public_files#show",
      )
      found = matcher.route_found?(route)
      expect(found).to be true

      route = Jets::Route.new(
        path: "posts/:id/edit",
        method: :get,
        to: "posts#edit",
      )
      found = matcher.route_found?(route)
      expect(found).to be true

      route = matcher.find_route
      expect(route.path).to eq "posts/:id/edit"
      expect(route.method).to eq "GET"
    end
  end

  context "get posts/:id" do
    let(:env) do
      { "PATH_INFO" => "/posts/tung", "REQUEST_METHOD" => "GET" }
    end
    it "find_route" do
      route = matcher.find_route
      expect(route.path).to eq "posts/:id"
      expect(route.method).to eq "GET"
    end
  end

  context "get posts/:id with extension" do
    let(:env) do
      { "PATH_INFO" => "/posts/tung.png", "REQUEST_METHOD" => "GET" }
    end
    it "find_route" do
      route = matcher.find_route
      expect(route.path).to eq "posts/:id"
      expect(route.method).to eq "GET"
    end
  end

  context "get posts/:id with dash" do
    let(:env) do
      { "PATH_INFO" => "/posts/tung-nguyen", "REQUEST_METHOD" => "GET" }
    end
    it "find_route" do
      route = matcher.find_route
      expect(route.path).to eq "posts/:id"
      expect(route.method).to eq "GET"
    end
  end

  context "get posts/new" do
    let(:env) do
      { "PATH_INFO" => "/posts/new", "REQUEST_METHOD" => "GET" }
    end
    it "find_route exact match" do
      route = matcher.find_route
      expect(route.path).to eq "posts/new"
      expect(route.method).to eq "GET"
    end
  end

  context "get posts/:id" do
    let(:env) do
      { "PATH_INFO" => "/posts/tung/anything", "REQUEST_METHOD" => "GET" }
    end
    it "find_route slash at the end of the pattern disqualified the match" do
      route = matcher.find_route
      expect(route.path).to eq "*catchall"
    end
  end

  context "put posts/:id" do
    let(:env) do
      { "PATH_INFO" => "/posts/tung", "REQUEST_METHOD" => "PUT" }
    end
    it "find_route" do
      route = matcher.find_route
      expect(route.path).to eq "posts/:id"
      expect(route.method).to eq "PUT"
    end
  end

  context "get everything/else catchall route" do
    let(:env) do
      { "PATH_INFO" => "/everything/else", "REQUEST_METHOD" => "GET" }
    end

    it "route_found?" do
      route = Jets::Route.new(
        path: "*catchall",
        method: :get,
        to: "public_files#catchall",
      )
      found = matcher.route_found?(route)
      expect(found).to be true
    end

    it "find_route" do
      route = matcher.find_route
      expect(route.path).to eq "*catchall"
      expect(route.method).to eq "ANY"
    end
  end

  context "get posts/:id/edit" do
    let(:env) do
      { "PATH_INFO" => "/posts/tung/edit", "REQUEST_METHOD" => "GET" }
    end
    it "route_found?" do
      route = Jets::Route.new(
        path: "posts/:id/edit",
        method: :get,
        to: "posts#edit",
      )
      found = matcher.route_found?(route)
      expect(found).to be true
    end
  end

  context "any comments/hot with get" do
    let(:env) do
      { "PATH_INFO" => "/comments/hot", "REQUEST_METHOD" => "GET" }
    end
    it "route_found?" do
      route = Jets::Route.new(
        path: "comments/hot",
        method: :any,
        to: "comments#hot",
      )
      found = matcher.route_found?(route)
      expect(found).to be true
    end
  end

  context "any comments/hot with post" do
    let(:env) do
      { "PATH_INFO" => "/comments/hot", "REQUEST_METHOD" => "POST" }
    end
    it "route_found?" do
      route = Jets::Route.new(
        path: "comments/hot",
        method: :any,
        to: "comments#hot",
      )
      found = matcher.route_found?(route)
      expect(found).to be true
    end
  end

  context "any comments/hot with non-matching path" do
    let(:env) do
      { "PATH_INFO" => "/some/other/path", "REQUEST_METHOD" => "GET" }
    end
    it "route_found?" do
      route = Jets::Route.new(
        path: "comments/hot",
        method: :any,
        to: "comments#hot",
      )
      found = matcher.route_found?(route)
      expect(found).to be false
    end
  end

  context "get admin/pages" do
    let(:env) do
      { "PATH_INFO" => "/admin/pages", "REQUEST_METHOD" => "GET" }
    end
    it "route_found?" do
      route = Jets::Route.new(
        path: "admin/pages",
        method: :get,
        to: "admin/pages#index",
      )
      found = matcher.route_found?(route)
      expect(found).to be true
    end
  end

  context "get others/my/long/path - proxy path route" do
    let(:env) do
      { "PATH_INFO" => "others/my/long/path", "REQUEST_METHOD" => "GET" }
    end
    it "route_found?" do
      route = Jets::Route.new(
        path: "others/*proxy",
        method: :get,
        to: "others#all",
      )
      found = matcher.route_found?(route)
      expect(found).to be true
    end
  end

  context "get others/my/long/path - proxy path route" do
    let(:env) do
      { "PATH_INFO" => "others2/my/long/path", "REQUEST_METHOD" => "GET" }
    end
    it "not route_found?" do
      route = Jets::Route.new(
        path: "others/*proxy",
        method: :get,
        to: "others#all",
      )
      found = matcher.route_found?(route)
      expect(found).to be false
    end
  end
end
