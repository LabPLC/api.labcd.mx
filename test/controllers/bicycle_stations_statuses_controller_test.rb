require 'test_helper'

class BicycleStationsStatusesControllerTest < ActionController::TestCase
  setup do
    @bicycle_stations_status = bicycle_stations_statuses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bicycle_stations_statuses)
  end

  test "should create bicycle_stations_status" do
    assert_difference('BicycleStationsStatus.count') do
      post :create, bicycle_stations_status: { bikes: @bicycle_stations_status.bikes, id_station: @bicycle_stations_status.id_station, slots: @bicycle_stations_status.slots, status: @bicycle_stations_status.status }
    end

    assert_response 201
  end

  test "should show bicycle_stations_status" do
    get :show, id: @bicycle_stations_status
    assert_response :success
  end

  test "should update bicycle_stations_status" do
    put :update, id: @bicycle_stations_status, bicycle_stations_status: { bikes: @bicycle_stations_status.bikes, id_station: @bicycle_stations_status.id_station, slots: @bicycle_stations_status.slots, status: @bicycle_stations_status.status }
    assert_response 204
  end

  test "should destroy bicycle_stations_status" do
    assert_difference('BicycleStationsStatus.count', -1) do
      delete :destroy, id: @bicycle_stations_status
    end

    assert_response 204
  end
end
