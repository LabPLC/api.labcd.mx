require 'httparty'
class BicycleStationsController < ApplicationController
  def index
    @bicycle_stations = BicycleStation.all
    
    unless BicycleStations.are_up_to_date?(@bicycle_stations)
      BicycleStation.destroy_all
      @bicycle_stations = BicycleStations.reload_stations(url: ecobici_api_url, access_token: ecobici_temporal_key.access_token)
      @bicycle_stations.each(&:save)
    end

    render json: BicycleStations.stations_for(@bicycle_stations)
  end

  def show
    @bicycle_station = bicycle_station

    unless @bicycle_station.status_is_present?
      bicycle_stations = BicycleStations.reload_stations_status(url: ecobici_status_api_url, access_token: ecobici_temporal_key.access_token, records: BicycleStation.all)
      bicycle_stations.each(&:save)
    end

    render json: BicycleStations.station_status_response(@bicycle_station.reload)
  end

  private

  def bicycle_station
    BicycleStation.find_by_id_station(params[:id])
  end

  def ecobici_api_url
    "https://pubsbapi.smartbike.com/api/v1/stations.json"
  end

  def ecobici_status_api_url
    "https://pubsbapi.smartbike.com/api/v1/stations/status.json"
  end

  def bicycle_station_params
    params.require(:bicycle_station).permit(:id_station, :name, :address, :addressNumber, :zipCode, :districtCode, :nearbyStations, :location, :stationType)
  end
end