require 'test_helper'

class BicycleStationsControllerTest < ActionController::TestCase
  setup do
    @bicycle_station = bicycle_stations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bicycle_stations)
  end

  test "should create bicycle_station" do
    assert_difference('BicycleStation.count') do
      post :create, bicycle_station: { address: @bicycle_station.address, addressNumber: @bicycle_station.addressNumber, districtCode: @bicycle_station.districtCode, id_station: @bicycle_station.id_station, location: @bicycle_station.location, name: @bicycle_station.name, nearbyStations: @bicycle_station.nearbyStations, stationType: @bicycle_station.stationType, zipCode: @bicycle_station.zipCode }
    end

    assert_response 201
  end

  test "should show bicycle_station" do
    get :show, id: @bicycle_station
    assert_response :success
  end

  test "should update bicycle_station" do
    put :update, id: @bicycle_station, bicycle_station: { address: @bicycle_station.address, addressNumber: @bicycle_station.addressNumber, districtCode: @bicycle_station.districtCode, id_station: @bicycle_station.id_station, location: @bicycle_station.location, name: @bicycle_station.name, nearbyStations: @bicycle_station.nearbyStations, stationType: @bicycle_station.stationType, zipCode: @bicycle_station.zipCode }
    assert_response 204
  end

  test "should destroy bicycle_station" do
    assert_difference('BicycleStation.count', -1) do
      delete :destroy, id: @bicycle_station
    end

    assert_response 204
  end
end
