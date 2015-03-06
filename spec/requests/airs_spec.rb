require 'rails_helper'

describe 'Airs' do
  describe 'GET index' do
    it 'returns the air quality element' do
      get '/air_qualities'
      air = JSON.parse(response.body)

      expect(response_endpoint_keys_in(body: air, children: [
        "id",
        "title",
        "link",
        "description",
        "reporte",
        "imagenclima",
        "gradosclima",
        "calairuser",
        "colairuser",
        "iconairuser",
        "colairno",
        "calairno",
        "colairne",
        "calairne",
        "colairce",
        "calairce",
        "colairso",
        "calairso",
        "colairse",
        "calairse",
        "caliuvuser",
        "coliuvuser",
        "created_at",
        "updated_at"
      ]))

      expect(response.status).to be 200
    end
  end
end
