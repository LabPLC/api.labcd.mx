class BicycleStation < ActiveRecord::Base

  def status_is_present?
    status.present?
  end
end
