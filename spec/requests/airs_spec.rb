require 'rails_helper'

describe 'Airs' do
  describe 'GET index' do
    it 'returns stations list' do
      station = create :bicycle_station, created_at: 5.days.ago

      get '/air_qualities'
      air = JSON.parse(response.body)

      expect(air["id"].present?).to be
      expect(air["title"].present?).to be
      expect(air["link"].present?).to be
      expect(air["description"].present?).to be
      expect(air["reporte"].present?).to be
      expect(air["imagenclima"].present?).to be
      expect(air["gradosclima"].present?).to be
      expect(air["calairuser"].present?).to be
      expect(air["colairuser"].present?).to be
      expect(air["iconairuser"].present?).to be
      expect(air["colairno"].present?).to be
      expect(air["calairno"].present?).to be
      expect(air["colairne"].present?).to be
      expect(air["calairne"].present?).to be
      expect(air["colairce"].present?).to be
      expect(air["calairce"].present?).to be
      expect(air["colairso"].present?).to be
      expect(air["calairso"].present?).to be
      expect(air["colairse"].present?).to be
      expect(air["calairse"].present?).to be
      expect(air["caliuvuser"].present?).to be
      expect(air["coliuvuser"].present?).to be
      expect(air["created_at"].present?).to be
      expect(air["updated_at"].present?).to be

      expect(response.status).to be 200
      expect(response.body.present?).to be true
    end
  end
end
