require 'httparty'

module V1
  module Movilidad
    class BicycleStationsController < V1::BaseController

      def index
        @bicycle_stations = BicycleStation.all
        @bicycle_stations

        unless BicycleStations.are_up_to_date?(@bicycle_stations)
          BicycleStation.destroy_all
          @bicycle_stations = BicycleStations.reload_stations(url: ecobici_api_url, access_token: ecobici_temporal_key.access_token)
          @bicycle_stations.each(&:save)
        end

        render json: fetch_bicycle_stations_with_pagination(params[:page], 50)
      end

      def show
        @bicycle_station = bicycle_station

        if @bicycle_station.status_is_present?
          bicycle_stations = BicycleStations.reload_stations_status(url: ecobici_status_api_url, access_token: ecobici_temporal_key.access_token, records: bicycle_station)
          unless bicycle_stations.nil?
            bicycle_stations.save
          end
        end

        render json: fetch_bicycle_station(@bicycle_station)
      end

      private

      def fetch_bicycle_station(bicycle_station)
        key = "bicycle_station/#{bicycle_station.id}"
        return Rails.cache.fetch(key) if Rails.cache.fetch(key).present?

        Rails.cache.fetch(key) if Rails.cache.write(key, BicycleStations.station_status_response(bicycle_station.reload))
      end

      def fetch_bicycle_stations_with_pagination(page_number, limit)
        key = "bicycle_stations/#{page_number}"
        return Rails.cache.fetch(key) if Rails.cache.fetch(key).present?

        Rails.cache.fetch(key) if Rails.cache.write(key, BicycleStations.stations_for(@bicycle_stations.page(page_number).per(limit)))
      end

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

  end
end
