#encoding: utf-8
class SemoviTaxisController < ApplicationController
  @@wsdl = 'http://www.taxi.df.gob.mx/ws/ws_taxi?wsdl'
  @@exp_placa = /[abm][\d]{5}/i

  @@cliente = Burocracia::WS.new(@@wsdl) do |client|
    client.default_params = {'ps_pasword' => ENV['SEMOVI_TAXIS_PASSWORD']}
    client.default_action = :consulta
    client.default_response = :consulta_response

    client.response_parser = -> (data){
      keys = [:code, :placa, :marca_modelo, :status, :fecha]
      data = Hash[keys.zip(data[:return])]

      case data[:code]
        when "-3" then raise "Vehículo no localizado"
        when "-1" then raise "Credenciales incorrectas"
      end

      data[:fecha] = Time.parse(data[:fecha]) if data[:fecha] rescue nil
      data
    }
  end

  # GET /
  def index
    render json: [aviso: 'ingresa una placa ejemplo A05601']
  end

  # GET /placa{.json}
  def show
    placa = parsed_placa

    return render(status: 400, json: {error: 'placa inválida'}) unless placa

    render status: status, json: fetch_taxi(placa)
  end


  private
  # Valida y convierte params en placas que acepte el webservice
  #
  # @param params [Hash] Los parámetros del request
  #
  # @return [String, NilClass] la placa limpia
  def parsed_placa
    placa = params[:id].gsub(/[^abm\d]/i, '')
    if @@exp_placa.match(placa)
      placa.upcase
    end
  end

  def fetch_all_taxis
    key = "semovi_taxis/all_taxis"
    return Rails.cache.fetch(key) if Rails.cache.fetch(key).present?

    Rails.cache.fetch(key) if Rails.cache.write(key, search_all_plates)
  end

  def fetch_taxi(plate)
    key = "semovi_taxis/#{plate}"
    return Rails.cache.fetch(key) if Rails.cache.fetch(key).present?

    Rails.cache.fetch(key) if Rails.cache.write(key, search_plate(plate))
  end

  def search_all_plates
    fetch_taxis = Taxi.all
    fetch_taxis = [] if fetch_taxis.blank?
    fetch_taxis
  end

  def search_plate(plate)
    taxi = Taxi.where(placa: plate).first
    status = 200
    if !taxi
      status = 201
      begin
        taxi = Taxi.create @@cliente.call({'ps_placa' => plate})
      rescue Exception => e
        return render status: 500, json: {error: e.message}
      end
    end
    taxi
  end
end
