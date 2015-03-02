class FinanzasPagosController < ApplicationController
  @@wsdl = 'http://189.208.102.100/fut/utilerias/validador/val_ws_secure_server.php?wsdl'
  @@cliente = Burocracia::WS.new(@@wsdl) do |client|
    client.default_params = {
      pregunta: {
        usuario: ENV['FINANZAS_USUARIO'],
        password: ENV['FINANZAS_PASSWORD']
      }
    }

    client.default_action = :solicitar_validez
    client.default_response = :solicitar_validez_response

    client.response_parser = -> (data) {
      data[:respuesta]
    }
  end


  def show
    begin
      fecha = Date.parse(params[:fecha]) if params[:fecha]
    rescue
      return render json: {error: 'La fecha no viene en formato YYYY-MM-DD'}
    end


    query = {
      lc: params[:id],
      importe: params[:importe].to_f
    }
    # porque fechas no siempre son requeridas
    query[:fecha] = fecha

    begin
      response = @@cliente.call({pregunta: query})
    rescue Exception => e
      return render json: {error: e.message}
    end

    if response[:error].to_i > 0
      errores = response[:error_descripcion].split(/(?=[A-Z])/)
      response = {error: errores}
    else
      response = {valida: response[:valida].to_i==1}
    end

    render json: response
  end

end