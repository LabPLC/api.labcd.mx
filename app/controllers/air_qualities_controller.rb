class AirQualitiesController < ApplicationController
  before_action :set_air_quality, only: [:show, :update, :destroy]

  # GET /air_qualities
  # GET /air_qualities.json
  def index
    @air_qualities = AirQuality.all

    require 'open-uri'
    doc = Nokogiri::XML(open("http://148.243.232.110/xml/app/appcalidadaire.XML")).slop!
      puts  doc.monitoreoatmosferico.title.text

    render json: @air_qualities
  end

  # GET /air_qualities/1
  # GET /air_qualities/1.json
  def show
    render json: @air_quality
  end

  # POST /air_qualities
  # POST /air_qualities.json
  def create
    @air_quality = AirQuality.new(air_quality_params)

    if @air_quality.save
      render json: @air_quality, status: :created, location: @air_quality
    else
      render json: @air_quality.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /air_qualities/1
  # PATCH/PUT /air_qualities/1.json
  def update
    @air_quality = AirQuality.find(params[:id])

    if @air_quality.update(air_quality_params)
      head :no_content
    else
      render json: @air_quality.errors, status: :unprocessable_entity
    end
  end

  # DELETE /air_qualities/1
  # DELETE /air_qualities/1.json
  def destroy
    @air_quality.destroy

    head :no_content
  end

  private

    def set_air_quality
      @air_quality = AirQuality.find(params[:id])
    end

    def air_quality_params
      params.require(:air_quality).permit(:title, :link, :description, :reporte, :imagenclima, :gradosclima, :calairuser, :colairuser, :iconairuser, :colairno, :calairno, :colairne, :calairne, :colairce, :calairce, :colairso, :calairso, :colairse, :calairse, :imgiuvuser, :caliuvuser, :coliuvuser)
    end
end
