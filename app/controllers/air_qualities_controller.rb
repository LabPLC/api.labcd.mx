require 'httparty'
class AirQualitiesController < ApplicationController

  def index
    require 'open-uri'

    if Airs.air_qualities_exist?
      Airs.set_air_quality("http://148.243.232.110/xml/app/appcalidadaire.XML")
    end
    render json: Airs.get_air_quality
  end

  private

  def air_quality_params
    params.require(:air_quality).permit(:title, :link, :description, :reporte, :imagenclima, :gradosclima, :calairuser, :colairuser, :iconairuser, :colairno, :calairno, :colairne, :calairne, :colairce, :calairce, :colairso, :calairso, :colairse, :calairse, :imgiuvuser, :caliuvuser, :coliuvuser)
  end
end
