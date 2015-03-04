class AlertaAmberController < ApplicationController
 @@wsdl='http://172.19.80.208/ws/alertaamber.asmx?wsdl'

  def index
require 'savon'
client =Savon.client(wsdl: @@wsdl, log_level: :error, log: false)
puts client.operations
  end
end
