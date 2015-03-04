class VehiclesController < ApplicationController
 # before_action :set_vehicle, only: [:show, :update, :destroy]

  # GET /vehicles
  # GET /vehicles.json
  def index
  
    render json: [aviso: 'ingresa una placa ejemplo 819UTT']
  
  end

  # GET /vehicles/1
  # GET /vehicles/1.json
  def show
   save_vehicle(params[:id].upcase)
  end

  def save_vehicle(placa) 
        @vehicle = Vehicle.where(placa: placa).first

        if @vehicle.nil?
          save_all_information(placa)
        elsif @vehicle.created_at < Time.now - 1.day
           save_all_information(placa)
        end
       render json:   {
          :vehicle => Vehicle.where(placa: placa).first,
          :verifications =>Verification.where(id_vehicle: Vehicle.where(placa: placa).first),
         :infractions => Infraction.where(id_vehicle: Vehicle.where(placa: placa).first)
       }
  end


def save_all_information(placa)
  @url = "http://datos.labplc.mx/movilidad/vehiculos/#{placa}.json"
     json =  response = HTTParty.get(@url)
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


  # POST /vehicles
  # POST /vehicles.json
  def create
    @vehicle = Vehicle.new(vehicle_params)

    if @vehicle.save
      render json: @vehicle, status: :created, location: @vehicle
    else
      render json: @vehicle.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /vehicles/1
  # PATCH/PUT /vehicles/1.json
  def update
    @vehicle = Vehicle.find(params[:id])

    if @vehicle.update(vehicle_params)
      head :no_content
    else
      render json: @vehicle.errors, status: :unprocessable_entity
    end
  end

  # DELETE /vehicles/1
  # DELETE /vehicles/1.json
  def destroy
    @vehicle.destroy

    head :no_content
  end

  private

    def set_vehicle
      @vehicle = Vehicle.find(params[:id])
    end

    def vehicle_params
      params.require(:vehicle).permit(:placa, :fechas_adeudo_tenecia, :tiene_adeudo_tenencia)
    end
end
