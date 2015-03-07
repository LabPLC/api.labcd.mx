#encoding: utf-8
require "Key"

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

        taxi =    get_from_cache(plate) ||
                  fetch_taxi_from_db(plate) ||
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

      def fetch_taxi_from_db(plate)
        set_in_cache(plate, Taxi.find_by(placa: plate))
      end

      def look_for_taxi_in_external_api(plate)
        set_in_cache( plate, Taxi.create!(@@cliente.call({'ps_placa' => plate})) )
      end

      def set_in_cache(keyId, taxi)
        # check that there is an object initilized
        return nil if keyId.nil? || taxi.nil?

        key = Key.create(Taxi, keyId)
        if REDIS.set(key, taxi.to_json)
          puts "REDIS: SETTING VALUE FOR #{keyId}"
          taxi
        else
          raise "Wasn't able to set taxi in cache."
        end
      end

      def get_from_cache(keyId)
        key = Key.create(Taxi, keyId)
        value = REDIS.get(key)
        if value
          puts "REDIS: GETTING VALUE FOR #{keyId}"
          value
        end
      end
    end
  end
end
