class AirQuality < ActiveRecord::Base

  def self.today
    where("created_at >= ?", Time.zone.now.beginning_of_day)
  end
end
