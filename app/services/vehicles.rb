module Vehicles

def self.up_to_date?(placa) 
      exp_placa = '^(\d{3}[A-Z]{3})$'
          @vehicle = Vehicle.where(placa: placa).first
          puts @vehicle.created_at
          puts Time.now - 1.day
          puts @vehicle.created_at < Time.now.utc- 1.day
          if @vehicle.nil? || @vehicle.created_at < Time.now - 1.day
            puts 'true'
            return  true
          else
             puts 'false'
            return false
          end
  end

def self.vehicle_responce(placa)
         {
            :vehicle => Vehicle.where(placa: placa).first,
            :verifications =>Verification.where(id_vehicle: Vehicle.where(placa: placa).first),
           :infractions => Infraction.where(id_vehicle: Vehicle.where(placa: placa).first)
         }
end



def self.placa_valida(placa) 
   exp_placa = '^(\d{3}[A-Z]{3})$'
      if placa.upcase.match(exp_placa)
        return true
      end
      return false
end

  def self.reload_vehicle(url)
     json =  response = HTTParty.get(url)
      response = JSON.parse(json.body)

      Vehicle.where(placa: response['consulta']['tenencias']['placa'].upcase).destroy_all
      #Obtenemos tenencia
    a =   Vehicle.create(placa: response['consulta']['tenencias']['placa'].upcase, 
        fechas_adeudo_tenecia: response['consulta']['tenencias']['adeudos'],
        tiene_adeudo_tenencia: response['consulta']['tenencias']['tieneadeudos'])

      #Obtener Infracciones
      response['consulta']['infracciones'].each do |inf|

        Infraction.create(folio: inf['folio'], 
          fecha: inf['fecha'],
          situacion: inf['situacion'],
          motivo: inf['motivo'],
          fundamento: inf['fundamento'],
          sancion: inf['sancion'],
          id_vehicle: a.id
          )
      end 
      #ontener verificaciones
      response['consulta']['verificaciones'].each do |inf|
          Verification.create(vin: inf['vin'],
            marca: inf['marca'],
            submarca: inf['submarca'],
            modelo: inf['modelo'],
            combustible: inf['combustible'],
            certificado: inf['certificado'],
           cancelado: inf['cancelado'],
            vigencia:  inf['vigencia'],
            verificentro: inf['verificentro'],
            linea: inf['linea'],
            fecha_verificacion: inf['fecha_verificacion'],
            hora_verificacion: inf['hora_verificacion'],
            resultado: inf['resultado'],
            causa_rechazo: inf['causa_rechazo'],
            equipo_gdf: inf['equipo_gdf'],
            id_vehicle: a.id
            )
      end 

end
  
end