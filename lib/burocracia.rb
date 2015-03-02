module Burocracia

  class WS
    attr_reader :wsdl
    attr_accessor :default_params, :default_action, :default_response, :response_parser

    # Instancia un consumidor de webservice burocrático
    def initialize ep
      # el endpoint
      @wsdl = ep
      # el cliente de savon
      @cliente = Savon.client(wsdl: wsdl, log_level: :error, log: false)
      # configure.do para pobres
      yield self
    end


    def call message
      # porque burocracia deep_merge es necesario en vez de merge
      # see: FinanzasPagosControllers@show
      message = default_params.deep_merge(message) unless default_params.nil?

      begin
        response = @cliente.call default_action , message: message
      rescue Savon::SOAPFault => e
        # Se cagó mi petición
        raise "Error de backend: #{e.message}"
      rescue Net::ReadTimeout => e
        # Se cayó su server
        raise "Error de backend #{e.message}"
      end

      data = response.body
      data = data[default_response] unless default_response.nil?
      data = response_parser.call(data) if response_parser

      data
    end


  end

end