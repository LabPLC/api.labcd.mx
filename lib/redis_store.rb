require "key"

module RedisStore
  def self.fetch_item_from_cache_or_locally_for(class_type, object_id, search_params)
    get_from_cache(class_type, object_id) || fetch_from_db(class_type, object_id, search_params)
  end

  def self.fetch_from_db(class_type, object_id, search_params)
    object = class_type.find_by(search_params)
    set_in_cache(class_type, object, object_id)
  end

  def self.get_from_cache(class_type, object_id)
    key = Key.create(class_type, object_id)
    value = REDIS.get(key)
    if value
      Rails.logger.info "REDIS: GETTING VALUE FOR #{key}"
      value
    end
  end

  def self.set_in_cache(class_type, object, object_id)
    # check that there is an object initilized
    return nil if object_id.nil? || object.nil?

    key = Key.create(class_type, object_id)
    if REDIS.set(key, object.to_json)
      Rails.logger.info "REDIS: SETTING VALUE FOR #{key}"
      object
    else
      raise "Wasn't able to set object in cache."
    end
  end
end
