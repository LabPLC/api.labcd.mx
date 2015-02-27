class AirQualitiesController < ApplicationController
  before_action :set_air_quality, only: [:show, :update, :destroy]

  # GET /air_qualities
  # GET /air_qualities.json
  def index
    require 'open-uri'
    @air_qualities = AirQuality.all.last
    if @air_qualities.nil?
      consultaInicial
    else
      consulta
    end  
    render json: @air_qualities
  end

  def consultaInicial
    llenado
    @air_qualities = AirQuality.all.last
  end

  def consulta
    if AirQuality.today.where(reporte: Time.now.in_time_zone("America/Mexico_City").hour).empty?
      llenado
    else
      @air_qualities = AirQuality.all.last
    end
  end


def llenado
    AirQuality.delete_all
    doc = Nokogiri::XML(open("http://148.243.232.110/xml/app/appcalidadaire.XML")).slop!
      AirQuality.create(
        title: doc.monitoreoatmosferico.title.text, 
        link: doc.monitoreoatmosferico.link.text,
        description: 'SEDEMA Calidad del aire',
        reporte: doc.monitoreoatmosferico.calidadaire.reporte.text,
        imagenclima: doc.monitoreoatmosferico.calidadaire.imagenclima.text,
        gradosclima:  doc.monitoreoatmosferico.calidadaire.gradosclima.text,
        calairuser: doc.monitoreoatmosferico.calidadaire.calairuser.text,
        colairuser: doc.monitoreoatmosferico.calidadaire.colairuser.text,
        iconairuser: doc.monitoreoatmosferico.calidadaire.iconairuser.text,
        colairno: doc.monitoreoatmosferico.calidadaire.colairno.text,
        calairno: doc.monitoreoatmosferico.calidadaire.calairno.text,
        colairne: doc.monitoreoatmosferico.calidadaire.colairne.text,
        calairne: doc.monitoreoatmosferico.calidadaire.calairne.text,
        colairce: doc.monitoreoatmosferico.calidadaire.colairce.text,
        calairce: doc.monitoreoatmosferico.calidadaire.calairce.text,
        colairso: doc.monitoreoatmosferico.calidadaire.colairso.text,
        calairso: doc.monitoreoatmosferico.calidadaire.calairso.text,
        colairse: doc.monitoreoatmosferico.calidadaire.colairse.text,
        calairse: doc.monitoreoatmosferico.calidadaire.calairse.text,
        caliuvuser: doc.monitoreoatmosferico.calidadaire.caliuvuser.text,
        coliuvuser: doc.monitoreoatmosferico.calidadaire.coliuvuser.text
    )
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
