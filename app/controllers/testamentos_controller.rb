  class TestamentosController < ApplicationController
require 'openssl'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

    @@wsdl = 'https://187.210.31.214:8443/WSConsulta/Consultas?wsdl'
  @@cliente = Burocracia::WS.new(@@wsdl) do |client|
    client.default_action = :consulta_municipio
    client.default_response = :consulta_municipio_response
    end


    def index
      render json: {error: 'Not implemented'}, status: 501
    end


    # GET /municipio=[municipio_name]
    def show


      begin
      response = @@cliente.call({:nombre_municipio => params[:id]})
      rescue Exception => e
        return render status: 500, json: {error: e.message}
      end

      render json: response
    end

  end