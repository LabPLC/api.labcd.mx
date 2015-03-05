require 'test_helper'

class VehiclesControllerTest < ActionController::TestCase
  setup do
    @vehicle = vehicles(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:vehicles)
  end

  test "should create vehicle" do
    assert_difference('Vehicle.count') do
      post :create, vehicle: { fechas_adeudo_tenecia: @vehicle.fechas_adeudo_tenecia, placa: @vehicle.placa, tiene_adeudo_tenencia: @vehicle.tiene_adeudo_tenencia }
    end

    assert_response 201
  end

  test "should show vehicle" do
    get :show, id: @vehicle
    assert_response :success
  end

  test "should update vehicle" do
    put :update, id: @vehicle, vehicle: { fechas_adeudo_tenecia: @vehicle.fechas_adeudo_tenecia, placa: @vehicle.placa, tiene_adeudo_tenencia: @vehicle.tiene_adeudo_tenencia }
    assert_response 204
  end

  test "should destroy vehicle" do
    assert_difference('Vehicle.count', -1) do
      delete :destroy, id: @vehicle
    end

    assert_response 204
  end
end
