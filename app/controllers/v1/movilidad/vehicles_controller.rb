module V1
  module Movilidad

    class VehiclesController < V1::BaseController

      def index
        render json: [aviso: 'ingresa una placa ejemplo 819UTT']
      end

      def show
        @placa = params[:id].upcase
        if Vehicles.up_to_date?(@placa)
          Vehicles.reload_vehicle("http://datos.labplc.mx/movilidad/vehiculos/#{@placa}.json")
          render json:  Vehicles.vehicle_responce(@placa)
        else
          render json:  ['error: placa invalida']
        end
        
      end

      def vehicle_params
        params.require(:vehicle).permit(:placa, :fechas_adeudo_tenecia, :tiene_adeudo_tenencia)
      end
    end

    

  end
end