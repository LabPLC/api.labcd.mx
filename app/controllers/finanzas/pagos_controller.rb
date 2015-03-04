#encoding: utf-8
module Finanzas
  class PagosController < ApplicationController
    before_action :ensure_valid_date_param

    # GET finanzas/pagos/consulta?linea_captura=[string]&importe=[float]&fechapago=[string]
    def consulta

      query_parameters = {
        lineacaptura: params[:lineacaptura] || params[:linea],
        importe: params[:importe],
        fechapago: params[:fechapago] || params[:fecha]
      }

      begin
        response = client.call({ pregunta: query_parameters })
      #rescue Exception => e
      #  return render status: 500, json: { error: e.message }
      end

      render json: WsdlClients.payment_response_for(response)
    end

    private

    def ensure_valid_date_param
      begin
        Date.parse(params[:fechapago]) if params[:fechapago]
      rescue ArgumentError
        render status: 400, json: { error: 'La fecha es inválida. Debe tener el formato YYYY-MM-DD'} and return
      end
    end

    def client
      WsdlClients.new_wsdl_client(
        url: finanzas_pagos_wsdl_url,
        params: {
          pregunta: {
            usuario: ENV['FINANZAS_USUARIO'],
            password: ENV['FINANZAS_PASSWORD']
          }
        },
        default_action: :consultar_pago,
        default_response: :consultar_pago_response,
        response_parser: -> (data) { data[:respuesta] }
      )
    end

    def finanzas_pagos_wsdl_url
      'http://189.208.102.100/formato_lc/utilerias/comprobador_pago/com_ws_secure_server.php?wsdl'
    end
  end
end