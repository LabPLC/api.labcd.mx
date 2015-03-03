require 'httparty'
class BicycleStationsController < ApplicationController
  # GET /bicycle_stations
  # GET /bicycle_stations.json
  def index
    @bicycle_stations = BicycleStation.all
    
    unless BicycleStations.are_up_to_date?(@bicycle_stations)
      BicycleStation.destroy_all
      @bicycle_stations = BicycleStations.reload_stations(url: ecobici_api_url, access_token: ecobici_temporal_key.access_token)
      @bicycle_stations.each(&:save)
    end

    render json: @bicycle_stations 
  end

  # GET /bicycle_stations/1
  # GET /bicycle_stations/1.json
  def show
    @bicycle_station = BicycleStation.find_by_id_station(params[:id])
    render json: @bicycle_station
  end

  private

  def ecobici_api_url
    "https://pubsbapi.smartbike.com/api/v1/stations.json"
  end

  def bicycle_station_params
    params.require(:bicycle_station).permit(:id_station, :name, :address, :addressNumber, :zipCode, :districtCode, :nearbyStations, :location, :stationType)
  end
end