module V1
  module Seguridad
    class CorralonesController < V1::BaseController

      def index
        render json: [aviso: 'ingresa una placa ejemplo 819UTT']
      end

      def show
        placa = params[:id].upcase
        render json:  Corralones.call_service("http://201.144.220.174/mpws/index.php/corralon/buscar_en_corralon", placa)
      end

    end
  end
end
