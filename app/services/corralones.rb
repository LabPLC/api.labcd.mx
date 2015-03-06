module Corralones

  def self.call_service(url, placa) 
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)

    data={
            key: ENV['SSP_CORRALONES'],
            placa: placa
        }        

        response = Net::HTTP::Post.new(uri.request_uri)
        response.set_form_data((data))
        response_json = JSON.parse(http.request(response).body)
        unless response_json['nombreCorralon'].nil?
        return http.request(response).body
      else
          [mensaje: 'Vehículo NO está en corralón']
      end

  end

end