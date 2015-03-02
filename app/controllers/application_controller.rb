class ApplicationController < ActionController::API

      def get_llave
      @llave = Save.all.last
      if  @llave.nil?
        obtener_llave
      elsif  !llave_invalida
        obtener_llave
      end
      @llave = Save.all.last
      puts @llave
    end

    def llave_invalida
      fecha_actual = Time.now.in_time_zone("America/Mexico_City")
      @llave.fecha.to_time+1.hours > fecha_actual 
    end

    def obtener_llave
      url = 'https://pubsbapi.smartbike.com/oauth/v2/token?client_id=121_2w73hco7wim8cs8ogkkso8kwwokcwwwoc0sw4448okogg4k04g&client_secret=e59lz46vys08kwgo0g4w4k0ow8gw8g8sg08scs4gkkg4w8os4&grant_type=client_credentials'
      response = response = HTTParty.get(url)
      json = JSON.parse(response.body)
      Save.delete_all
      Save.create(access_token: json['access_token'], fecha: Time.now.in_time_zone("America/Mexico_City"))
    end

end
