require 'savon'
class AlertaAmberController < ApplicationController
 @@wsdl = 'http://187.217.178.196/wsalertaamber.asmx?wsdl'
    @@cliente = Burocracia::WS.new(@@wsdl) do |client|
      client.default_params = {
          tr: '1'
      }

      client.default_action = :solicitar_validez
      client.default_response = :solicitar_validez_response

      client.response_parser = -> (data) {
        data[:respuesta]
      }
end
 def index
    
      begin
        response = @@cliente.call({'tr' => 1})
      rescue Exception => e
        return render status: 500, json: {error: e.message}
      end

      render json: response
end

end
