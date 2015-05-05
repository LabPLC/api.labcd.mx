module Vehicles

def self.up_to_date?(placa) 
      exp_placa = '^((\d{3}[A-Z]{2,3})|([A-Z]{1}\d{2}[A-Z]{3})|([A-Z]{3}\d{4})|([A-Z]{1}\d{5})|(\d{5})|([A-Z]{1}\d{3}[A-Z]{1})|([A-Z]{3}\d{2}))$'
      if placa.upcase.match(exp_placa)
          @vehicle = Vehicle.where(placa: placa).first

          if @vehicle.nil? || @vehicle.created_at < Time.now - 1.day
            return  true
          else
            return false
          end
      end
      return   false
  end

def self.vehicle_responce(placa)
         {
            :vehicle => Vehicle.where(placa: placa).first,
            :verifications =>Verification.where(id_vehicle: Vehicle.where(placa: placa).first),
           :infractions => Infraction.where(id_vehicle: Vehicle.where(placa: placa).first)
         }
end


  def self.reload_vehicle(url)
     json =  response = HTTParty.get(url)
      response = JSON.parse(json.body)
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