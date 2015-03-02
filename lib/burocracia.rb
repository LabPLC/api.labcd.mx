module Burocracia

  class WS
    attr_reader :wsdl
    attr_accessor :default_params, :default_action, :default_response, :response_parser

    def initialize ep
      @wsdl = ep
      @cliente = Savon.client(wsdl: wsdl, log_level: :error, log: false)
      yield self
    end


    def call message
      message = default_params.deep_merge(message) unless default_params.nil?

      begin
        response = @cliente.call default_action , message: message
      rescue Savon::SOAPFault => e
        raise "Error de backend: #{e.message}"
      rescue Net::ReadTimeout => e
        raise "Error de backend #{e.message}"
      end

      data = response.body
      data = data[default_response] unless default_response.nil?
      data = response_parser.call(data) if response_parser

      data
    end


  end

end