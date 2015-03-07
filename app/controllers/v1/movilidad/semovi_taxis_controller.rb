#encoding: utf-8
require "redis_store"

module V1
  module Movilidad
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

      def index
        render json: [aviso: 'ingresa una placa ejemplo A05601']
      end

      def show
        plate = parse_vehicle_plate
        # Let's check for the taxi plate in cache

        taxi =    RedisStore.fetch_item_from_cache_or_locally_for(Taxi, plate, { placa: plate }) ||
                  look_for_taxi_in_external_api(plate)

        if taxi
          render status: status, json: taxi
        else
          render(status: 400, json: {error: 'Placa inválida.'})
        end
      end


      private

      def parse_vehicle_plate
        # Valida y convierte params en placas que acepte el webservice
        #
        # @param params [Hash] Reques parameters
        #
        # @return [String, NilClass] Clean plate

        placa = params[:id].gsub(/[^abm\d]/i, '')
        if @@exp_placa.match(placa)
          placa.upcase
        end
      end

      def look_for_taxi_in_external_api(plate)
        set_in_cache( plate, Taxi.create!(@@cliente.call({'ps_placa' => plate})) )
      end
    end
  end
end
