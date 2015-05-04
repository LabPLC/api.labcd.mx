module V1
  module Seguridad
    class CorralonesController < V1::BaseController

      def index
        render json: [aviso: 'ingresa una placa ejemplo 819UTT']
      end

      def show
        placa = params[:id].upcase
          exp_placa = '^((\d{3}[a-zA-Z]{3})|([a-zA-Z]{1}\d{2}[a-zA-Z]{3})|([a-zA-Z]{3}\d{3,4})|([a-zA-Z]{1}\d{5}))$'
        if placa.match(exp_placa)
          render json:  Corralones.call_service("http://201.144.220.174/mpws/index.php/corralon/buscar_en_corralon", placa)
        else
           render json:  ['error: placa invalida']
         end 
       
      end

    end
  end
end
