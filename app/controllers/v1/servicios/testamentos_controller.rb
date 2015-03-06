module V1
  module Servicios
    class TestamentosController < ApplicationController
      @@wsdl = 'https://187.210.31.214:8443/WSConsulta/Consultas?wsdl'


      def index
        begin
          case params[:tipo]
          when 'municipio'
            @@cliente = Burocracia::WS.new(@@wsdl) do |client|
              client.default_action = :consulta_municipio
              client.default_response = :consulta_municipio_response
            end
            response = @@cliente.call({:nombre_municipio => params[:municipio] })

          when 'edo_fecha_captura'
            @@cliente = Burocracia::WS.new(@@wsdl) do |client|
              client.default_action = :consulta_edo_fecha_captura
              client.default_response = :consulta_edo_fecha_captura_response
            end
            response = @@cliente.call({:nombre_estado => params[:nombre_estado],:fecha_inicio => params[:fecha_inicio],:fecha_final => params[:fecha_final] })

          when 'estado'
            @@cliente = Burocracia::WS.new(@@wsdl) do |client|
              client.default_action = :consulta_estado
              client.default_response = :consulta_estado_response
            end
            response = @@cliente.call({:nombre_estado => params[:nombre_estado]})

          when 'fecha_nacimiento_list'
            @@cliente = Burocracia::WS.new(@@wsdl) do |client|
              client.default_action = :fecha_nacimiento_list
              client.default_response = :fecha_nacimiento_list_response
            end
            response = @@cliente.call({:fecha_inicio => params[:fecha_inicio],:fecha_final => params[:fecha_final]})

          when 'lista'
            @@cliente = Burocracia::WS.new(@@wsdl) do |client|
              client.default_action = :consulta_lista
              client.default_response = :consulta_lista_response
            end
            response = @@cliente.call({:fecha_inicio => params[:fecha_inicio],:fecha_final => params[:fecha_final] })

          when 'por_fecha_captura_municipio'
            @@cliente = Burocracia::WS.new(@@wsdl) do |client|
              client.default_action = :consulta_por_fecha_captura_municipio
              client.default_response = :consulta_por_fecha_captura_municipio_response
            end
            response = @@cliente.call({:nombre_municipio => params[:nombre_municipio],:fecha_inicio => params[:fecha_inicio],:fecha_final => params[:fecha_final] })

          when 'semanas_list'
            @@cliente = Burocracia::WS.new(@@wsdl) do |client|
              client.default_action = :consulta_edo_fecha_captura
              client.default_response = :consulta_edo_fecha_captura_response
            end    
            response = @@cliente.call({:fecha_inicio => params[:fecha_inicio],:fecha_final => params[:fecha_final] })
          else
            response = [error: 'URL mal formada']
          end
        rescue Exception => e
          return render status: 500, json: {error: e.message}
        end

        render json: response
      end

    end
  end
end
