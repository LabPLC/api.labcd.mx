#encoding: utf-8

module V1
  module Movilidad
    class SemoviTaxisController < V1::BaseController
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
        @taxis = Taxi.all
        if @taxis.nil?
          # debería de regresar un 204, pero rails no regresa content con eso
          return render json: []
        end
        render json: @taxis
      end

      # GET /placa{.json}
      def show
        placa = parsed_placa

        return render(status: 400, json: {error: 'placa inválida'}) unless placa

        @taxi = Taxi.where(placa: placa).first
        status = 200
        if !@taxi
          status = 201
          begin
            @taxi = Taxi.create @@cliente.call({'ps_placa' => placa})
          rescue Exception => e
            return render status: 500, json: {error: e.message}
          end
        end

        render status: status, json: @taxi
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
    end
  end
end
