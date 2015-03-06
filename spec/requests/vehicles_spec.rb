require 'rails_helper'

describe 'Vehicles' do
  describe 'GET show' do
    it 'returns the vehicle information' do
      get '/vehicles/819UTT'

      vehicle = JSON.parse(response.body)

      expect(response_endpoint_keys_in(body: vehicle, parent: "vehicle", children: [
        "id",
        "placa",
        "fechas_adeudo_tenecia",
        "tiene_adeudo_tenencia",
        "created_at",
        "updated_at"
        ])).to be

        expect(response_endpoint_keys_in(body: vehicle, parent: "verifications", children: [
          "id",
          "vin",
          "marca",
          "submarca",
          "modelo",
          "combustible",
          "certificado",
          "cancelado",
          "vigencia",
          "verificentro",
          "linea",
          "fecha_verificacion",
          "hora_verificacion",
          "resultado",
          "causa_rechazo",
          "equipo_gdf",
          "created_at",
          "updated_at",
          "id_vehicle"
        ])).to be

        expect(response_endpoint_keys_in(body: vehicle, parent: "infractions", children: [
          "id",
          "folio",
          "fecha",
          "situacion",
          "motivo",
          "fundamento",
          "sancion",
          "created_at",
          "updated_at",
          "id_vehicle"
        ])).to be
    end
  end
end
