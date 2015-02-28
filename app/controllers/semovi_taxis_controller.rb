class SemoviTaxisController < ApplicationController
  @@wsdl = 'http://www.taxi.df.gob.mx/ws/ws_taxi?wsdl'
  @@exp_placa = /[abm][\d]{5}/i
  @@client = Savon.client(wsdl: @@wsdl, log_level: :error, log: false)


  def index
    @taxis = Taxi.all
    if @taxi.nil?
      render json: []
    end

    render json: @taxis
  end


  def parsed_placa params
    return nil unless params.include? :id
    placa = params[:id].gsub(/[^abm\d]/i, '')
    return nil unless @@exp_placa.match(placa)
    return placa.upcase
  end


  def do_soap placa
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

    if data[:code] == "-3"
      raise "Vehículo no localizado"
    end

    data[:fecha] = Time.parse(data[:fecha]) if data[:fecha] rescue nil
    data
  end




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

end