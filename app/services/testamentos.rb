module Testamentos

def self.municipio_find(cliente ,municipio)
   
       begin
        response = cliente.call({:nombre_municipio => municipio})
      rescue Exception => e
        return render status: 500, json: {error: e.message}
      end
end

end