require 'test_helper'

class CountriesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  should_not_respond_to_actions :new => :get, :destroy => :get

  setup do
    @country = countries(:one)
    @user = users(:user)
  end

  # I really dunno why I need to do this, the naming convention is ok
  def setup
    @controller = CountriesController.new
  end

  test "should get index" do
    sign_in @user
    get :index
    assert_response :success
    assert_not_nil assigns(:countries)
  end

  test "should show country" do
    sign_in @user
    get :show, :id => @country.to_param
    assert_response :success
  end

end