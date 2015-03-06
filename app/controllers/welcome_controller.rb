class WelcomeController < ApplicationController

  WELCOME_MESSAGE = {
    message: "Bienvenido a las APIs del Laboratorio para la Ciudad.",
    docs_url: "https://github.com/LabPLC/api.labcd.mx/wiki",
    api_version: 1,
    base_url: 'http://api.labcd.mx/v1/'
  } 

  def index
    render json: WELCOME_MESSAGE, status: :ok
  end

end
