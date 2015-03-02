class SemoviTaxisController < ApplicationController
  @@wsdl = 'http://www.taxi.df.gob.mx/ws/ws_taxi?wsdl'
  @@exp_placa = /[abm][\d]{5}/i
  @@client = Savon.client(wsdl: @@wsdl, log_level: :error, log: false)


  # GET /
  def index
    @taxis = Taxi.all
    if @taxi.nil?
      return render json: []
    end

    render json: @taxis
  end

  # GET /placa{.json}
  def show
    placa = parsed_placa(params)

    return render(json: {error: 'placa inválida'}) unless placa

    @taxi = Taxi.where(placa: placa).first
    if !@taxi
      begin
        @taxi = Taxi.create do_soap(placa)
      rescue Exception => e
        return render json: {error: e.message}
      end
    end

    render json: @taxi
  end


  private
  # Valida y convierte params en placas que acepte el webservice
  #
  # @param params [Hash] Los parámetros del request
  #
  # @return [String, NilClass] la placa limpia
  def parsed_placa params
    return nil unless params.include? :id
    placa = params[:id].gsub(/[^abm\d]/i, '')
    return nil unless @@exp_placa.match(placa)
    return placa.upcase
  end


  # Ejecuta el call al webservice
  #
  # @param [String] placa una placa limipia
  #
  # @return [Hash] el objeto de un taxi
  def do_soap placa
    # strings porque savon
    message = {
      'ps_pasword' => ENV['SEMOVI_TAXIS_PASSWORD'],
      'ps_placa' => placa
    }

    begin
      response = @@client.call :consulta, message: message
    rescue Savon::SOAPFault => e
      raise "Error de backend: #{e.message}"
    rescue Net::ReadTimeout => e
      raise "Error de backend #{e.message}"
    end

    keys = [:code, :placa, :marca_modelo, :status, :fecha]
    data = Hash[keys.zip(response.body[:consulta_response][:return])]

    case data[:code]
      when "-3" then raise "Vehículo no localizado"
      when "-1" then raise "Credenciales incorrectas"
    end

    data[:fecha] = Time.parse(data[:fecha]) if data[:fecha] rescue nil
    data
  end

end