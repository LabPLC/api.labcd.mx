module WsdlClients
  def self.new_wsdl_client(url:, params:, default_action:, default_response:, response_parser:)
    WS.new(
      url: url,
      default_params: params,
      default_action: default_action,
      default_response: default_response,
      response_parser: response_parser
    )
  end

  def self.payment_response_for(response)
    {
      consulta: {
        pagada: response[:pagada],
        error: response[:error],
        error_descripcion: response[:error_descripcion] 
      }
    }
  end

  class WS
    attr_reader :wsdl

    # Instancia un consumidor de webservice burocrático
    def initialize(attrs)
      # el endpoint
      @wsdl = attrs[:url]
      # el cliente de savon
      @savon_client = Savon.client(wsdl: wsdl, log_level: :error, log: false)
      # configure.do para pobres
      @default_params = attrs[:default_params] || {}
      @default_action = attrs[:default_action]
      @default_response = attrs[:default_response]
      @response_parser = attrs[:response_parser]
    end


    def call(message)
      message = default_params.deep_merge(message) unless default_params.nil?

      begin
        response = savon_client.call default_action , message: message      
      rescue Savon::SOAPFault => e
        # Se cagó mi petición
        raise "Error de backend: #{e.message}"
      rescue Net::ReadTimeout => e
        # Se cayó su server
        raise "Error de backend #{e.message}"
      end

      data = response.body
      data = data[default_response] if default_response.present?
      data = response_parser.call(data) if response_parser.present?

      data
    end

    private
    attr_reader :savon_client, :default_params, :default_action, :default_response, :response_parser
  end
end