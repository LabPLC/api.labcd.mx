class Vehicle < ActiveRecord::Base
  has_many :verifications
  has_many :infractions
end
