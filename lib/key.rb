module Key
  def self.create(classObject, id)
    "#{classObject.name}::#{id}"
  end
end
