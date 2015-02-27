class SemoviTaxis < ApplicationController
  @wsdl = 'http://www.taxi.df.gob.mx/ws/ws_taxi?wsdl'
  @exp_placa = /[abm][\d]{5}/i


  def index
    @taxis = Taxi.all
    if @taxi.nil?
      render json: []
    end

    render json: @taxis
  end


  def parsed_placa params
    return nil unless params.include? :placa
    placa = params[:placa].gsub(/[abm\d]/, '')
    return nil unless @exp_placa.match(params:placa)
    placa.upcase
  end


  def do_soap placa
    message = {
      'ps_pasword' => ENV['semovi.taxis.password'],
      'ps_placa' => placa
    }

    client = Savon.client(wsdl: @wsdl, log_level: :error, log: false)

    begin
      response = client.call :consulta, message: message
    rescue Savon::SOAPFault => e
      raise "Error de backend: e.message"
    end

    keys = [:code, :placa, :marca_modelo, :status, :fecha]
    data = Hash[keys.zip(response.body[:consulta_response][:return])]

    if data[:code] == "-3"
      raise "Vehículo no localizado"
    end

    data[:fecha] = Time.parse(data[:fecha]) if data[:fecha] rescue nil
    data
  end




  def consulta
    placa = parsed_placa(params)

    return render(json: {error: 'placa inválida'}) unless placa

    if @taxi = Taxi.where(placa: params[:placa])
      render json: @taxi
    else
      begin
        @taxi = Taxi.create do_soap(placa)
      rescue Exception => e
        return render json: {error: e.message}
      end
    end


  end

end