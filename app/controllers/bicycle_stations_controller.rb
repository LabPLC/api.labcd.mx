class BicycleStationsController < ApplicationController
  before_action :set_bicycle_station, only: [:show, :update, :destroy]

  # GET /bicycle_stations
  # GET /bicycle_stations.json
  def index
    require 'httparty'
    require 'json'
    get_llave#obtenemos la llava temporal
    obtener_estaciones #obtenemos las estaciones
    render json: @bicycle_stations 
  end


  def obtener_estaciones
    @bicycle_stations = BicycleStation.all
    if estaciones_no_guardadas
      guardar_estaciones
    else
      @bicycle_stations
    end
  end

    def estaciones_no_guardadas
      if @bicycle_stations.empty?
        true
      else
        unless BicycleStation.last.created_at <  Time.now - 10.day
          return false
        else
          return true
        end
      end
    end


    def guardar_estaciones
         BicycleStation.delete_all
          url = "https://pubsbapi.smartbike.com/api/v1/stations.json?access_token=#{@llave.access_token}"
         json =  response = HTTParty.get(url)
          response = JSON.parse(json.body)
          response['stations'].each do |res|
            BicycleStation.create(
              id_station: res['id'],
              name: res['name'],
              address: res['address'],
              addressNumber: res['addressNumber'],
              zipCode: res['zipCode'],
              districtCode: res['districtCode'],
              nearbyStations: neighborhood(res['nearbyStations']),
              location: geopunto(res['location']['lat'],res['location']['lon']),
              stationType: res['stationType']
              )
          end
    end



    def geopunto(lat, lon)
        lat.to_s + ',' + lon.to_s
    end

    def neighborhood(arreglo)
      arreglo.map(&:inspect).join(', ')
    end


  # GET /bicycle_stations/1
  # GET /bicycle_stations/1.json
  def show
    render json: @bicycle_station
  end

  # POST /bicycle_stations
  # POST /bicycle_stations.json
  def create
    @bicycle_station = BicycleStation.new(bicycle_station_params)

    if @bicycle_station.save
      render json: @bicycle_station, status: :created, location: @bicycle_station
    else
      render json: @bicycle_station.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /bicycle_stations/1
  # PATCH/PUT /bicycle_stations/1.json
  def update
    @bicycle_station = BicycleStation.find(params[:id])

    if @bicycle_station.update(bicycle_station_params)
      head :no_content
    else
      render json: @bicycle_station.errors, status: :unprocessable_entity
    end
  end

  # DELETE /bicycle_stations/1
  # DELETE /bicycle_stations/1.json
  def destroy
    @bicycle_station.destroy

    head :no_content
  end

  private

  def set_bicycle_station
    @bicycle_station = BicycleStation.find(params[:id])
  end

  def bicycle_station_params
    params.require(:bicycle_station).permit(:id_station, :name, :address, :addressNumber, :zipCode, :districtCode, :nearbyStations, :location, :stationType)
  end
end
