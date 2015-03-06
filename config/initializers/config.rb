# setting up the cache store
ActionController::Base.cache_store = :memory_store, { size: 64.megabytes }
