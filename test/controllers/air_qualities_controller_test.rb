require 'test_helper'

class AirQualitiesControllerTest < ActionController::TestCase
  setup do
    @air_quality = air_qualities(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:air_qualities)
  end

  test "should create air_quality" do
    assert_difference('AirQuality.count') do
      post :create, air_quality: { calairce: @air_quality.calairce, calairne: @air_quality.calairne, calairno: @air_quality.calairno, calairse: @air_quality.calairse, calairso: @air_quality.calairso, calairuser: @air_quality.calairuser, caliuvuser: @air_quality.caliuvuser, colairce: @air_quality.colairce, colairne: @air_quality.colairne, colairno: @air_quality.colairno, colairse: @air_quality.colairse, colairso: @air_quality.colairso, colairuser: @air_quality.colairuser, coliuvuser: @air_quality.coliuvuser, description: @air_quality.description, gradosclima: @air_quality.gradosclima, iconairuser: @air_quality.iconairuser, imagenclima: @air_quality.imagenclima, imgiuvuser: @air_quality.imgiuvuser, link: @air_quality.link, reporte: @air_quality.reporte, title: @air_quality.title }
    end

    assert_response 201
  end

  test "should show air_quality" do
    get :show, id: @air_quality
    assert_response :success
  end

  test "should update air_quality" do
    put :update, id: @air_quality, air_quality: { calairce: @air_quality.calairce, calairne: @air_quality.calairne, calairno: @air_quality.calairno, calairse: @air_quality.calairse, calairso: @air_quality.calairso, calairuser: @air_quality.calairuser, caliuvuser: @air_quality.caliuvuser, colairce: @air_quality.colairce, colairne: @air_quality.colairne, colairno: @air_quality.colairno, colairse: @air_quality.colairse, colairso: @air_quality.colairso, colairuser: @air_quality.colairuser, coliuvuser: @air_quality.coliuvuser, description: @air_quality.description, gradosclima: @air_quality.gradosclima, iconairuser: @air_quality.iconairuser, imagenclima: @air_quality.imagenclima, imgiuvuser: @air_quality.imgiuvuser, link: @air_quality.link, reporte: @air_quality.reporte, title: @air_quality.title }
    assert_response 204
  end

  test "should destroy air_quality" do
    assert_difference('AirQuality.count', -1) do
      delete :destroy, id: @air_quality
    end

    assert_response 204
  end
end
