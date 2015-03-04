module Airs
    include HTTParty

    def self.air_qualities_exist?
      get_air_quality.nil? || AirQuality.today.where(reporte: Time.now.in_time_zone("America/Mexico_City").hour).empty?
    end


def self.set_air_quality(url)
    AirQuality.delete_all
    doc = Nokogiri::XML(open(url)).slop!
      AirQuality.create(
        title: doc.monitoreoatmosferico.title.text, 
        link: doc.monitoreoatmosferico.link.text,
        description: 'SEDEMA Calidad del aire',
        reporte: doc.monitoreoatmosferico.calidadaire.reporte.text,
        imagenclima: doc.monitoreoatmosferico.calidadaire.imagenclima.text,
        gradosclima:  doc.monitoreoatmosferico.calidadaire.gradosclima.text,
        calairuser: doc.monitoreoatmosferico.calidadaire.calairuser.text,
        colairuser: doc.monitoreoatmosferico.calidadaire.colairuser.text,
        iconairuser: doc.monitoreoatmosferico.calidadaire.iconairuser.text,
        colairno: doc.monitoreoatmosferico.calidadaire.colairno.text,
        calairno: doc.monitoreoatmosferico.calidadaire.calairno.text,
        colairne: doc.monitoreoatmosferico.calidadaire.colairne.text,
        calairne: doc.monitoreoatmosferico.calidadaire.calairne.text,
        colairce: doc.monitoreoatmosferico.calidadaire.colairce.text,
        calairce: doc.monitoreoatmosferico.calidadaire.calairce.text,
        colairso: doc.monitoreoatmosferico.calidadaire.colairso.text,
        calairso: doc.monitoreoatmosferico.calidadaire.calairso.text,
        colairse: doc.monitoreoatmosferico.calidadaire.colairse.text,
        calairse: doc.monitoreoatmosferico.calidadaire.calairse.text,
        caliuvuser: doc.monitoreoatmosferico.calidadaire.caliuvuser.text,
        coliuvuser: doc.monitoreoatmosferico.calidadaire.coliuvuser.text
    )
end

def self.get_air_quality
  AirQuality.all.last
end

end