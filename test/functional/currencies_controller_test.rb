require 'test_helper'

class CurrenciesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  should_not_respond_to_actions :new => :get, 
                                :destroy => :get, 
                                :create => :post,
                                :edit => :get, 
                                :update => :put

  setup do
    @currency = currencies(:one)
    @user = users(:user)
  end

  # I really dunno why I need to do this, the naming convention is ok
  def setup
    @controller = CurrenciesController.new
  end

  test "should get index" do
    sign_in @user
    get :index
    assert_response :success
    assert_not_nil assigns(:currencies)
  end

  test "should show currency" do
    sign_in @user
    get :show, :id => @currency.to_param
    assert_response :success
  end
end