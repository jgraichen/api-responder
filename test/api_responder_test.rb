require 'test_helper'

class ApiResponderTest < ActionController::TestCase
  tests AppController

  def setup
    @resource = Resource.new
  end

  def test_formats_resource
    get :index, :format => :json, :resource => Resource.new

    assert_equal 406, response.status
  end

  def test_version_from_path
    get :v2, :format => :json, :resource => Resource.new

    assert_equal({"av" => 2}, JSON[response.body])
  end

  def test_custom_version
    @controller = CustomController.new
    @resource.expects(:as_api_v4).returns({"av" => "c4"})

    request.env["HTTP_ACCEPT"] = "application/vnd.test.v4+json"
    get :index, {:format => :json, :resource => @resource}

    assert_equal({"av" => "c4"}, JSON[response.body])
  end

  def test_custom_version_nil
    @controller = CustomController.new

    request.env["HTTP_ACCEPT"] = "application/vnd.test.v+json"
    get :index, {:format => :json, :resource => @resource}

    assert_equal 406, response.status
  end

  def test_custom_version_unsupported
    @controller = CustomController.new

    request.env["HTTP_ACCEPT"] = "application/vnd.test.v6+json"
    get :index, {:format => :json, :resource => @resource}

    assert_equal 406, response.status
  end
end
