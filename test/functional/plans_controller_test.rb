require File.dirname(__FILE__) + '/../test_helper'

class PlansControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:plans)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_plan
    assert_difference('Plan.count') do
      post :create, :plan => { }
    end

    assert_redirected_to plan_path(assigns(:plan))
  end

  def test_should_show_plan
    get :show, :id => plans(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => plans(:one).id
    assert_response :success
  end

  def test_should_update_plan
    put :update, :id => plans(:one).id, :plan => { }
    assert_redirected_to plan_path(assigns(:plan))
  end

  def test_should_destroy_plan
    assert_difference('Plan.count', -1) do
      delete :destroy, :id => plans(:one).id
    end

    assert_redirected_to plans_path
  end
end
