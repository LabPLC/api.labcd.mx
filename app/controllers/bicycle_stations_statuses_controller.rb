class BicycleStationsStatusesController < ApplicationController
  before_action :set_bicycle_stations_status, only: [:show, :update, :destroy]

  # GET /bicycle_stations_statuses
  # GET /bicycle_stations_statuses.json
  def index
    require 'httparty'
    require 'json'
    get_llave#obtenemos la llava temporal
    puts @llave.access_token
    obtener_status_estaciones #obtenemos las estaciones

    render json: @bicycle_stations_statuses
  end

  def obtener_status_estaciones
    @bicycle_stations_statuses= BicycleStationsStatus.all
    if candados_no_guardados
      guardar_candados
    else
      @bicycle_stations_statuses
    end
  end

  def candados_no_guardados
      if @bicycle_stations_statuses.empty?
        true
      else
        unless BicycleStationsStatus.last.created_at <  Time.now - 1.minutes
          return false
        else
          return true
        end
      end
    end



        def guardar_candados
         BicycleStationsStatus.delete_all
          url = "https://pubsbapi.smartbike.com/api/v1/stations/status.json?access_token=#{@llave.access_token}"
         json =  response = HTTParty.get(url)
          response = JSON.parse(json.body)
          response['stationsStatus'].each do |res|
            BicycleStationsStatus.create(
              id_station: res['id'],
              status: res['status'],
              bikes: res['availability']['bikes'],
              slots: res['availability']['slots']
              )
          end
    end

  # GET /bicycle_stations_statuses/1
  # GET /bicycle_stations_statuses/1.json
  def show
    render json: @bicycle_stations_status
  end

  # POST /bicycle_stations_statuses
  # POST /bicycle_stations_statuses.json
  def create
    @bicycle_stations_status = BicycleStationsStatus.new(bicycle_stations_status_params)

    if @bicycle_stations_status.save
      render json: @bicycle_stations_status, status: :created, location: @bicycle_stations_status
    else
      render json: @bicycle_stations_status.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /bicycle_stations_statuses/1
  # PATCH/PUT /bicycle_stations_statuses/1.json
  def update
    @bicycle_stations_status = BicycleStationsStatus.find(params[:id])

    if @bicycle_stations_status.update(bicycle_stations_status_params)
      head :no_content
    else
      render json: @bicycle_stations_status.errors, status: :unprocessable_entity
    end
  end

  # DELETE /bicycle_stations_statuses/1
  # DELETE /bicycle_stations_statuses/1.json
  def destroy
    @bicycle_stations_status.destroy

    head :no_content
  end

  private

    def set_bicycle_stations_status
      @bicycle_stations_status = BicycleStationsStatus.find(params[:id])
    end

    def bicycle_stations_status_params
      params.require(:bicycle_stations_status).permit(:id_station, :status, :bikes, :slots)
    end
end
