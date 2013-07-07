class Collection
  class << self
    def all(for_gender="both")
      collections = _read_all("*")
      collections.each do |collection|
        collection["created_by"] = User.get(collection["created_by"])
        collection["items"] = Item.get_bulk(collection["item_urls"])
      end
      collections
    end
    
    def find(id)
      _read(id)
    end
    
    def save(collection)
      Rails.logger.info "Collection to save" + collection.to_json
      _write(collection["cid"], collection)
    end
    
    def create(params)
      collection = {}
      collection["cid"] = _get_next_cid()
      collection["collection_name"] = params["cname"]
      collection["created_by"] = params["user_id"]
      collection["create_time"] = Time.now.utc
      ## Default karma is 0
      collection["karma"] = "0"
      ## TODO Get this from Vinit's search API
      collection["item_urls"] = params["itemurls"].first.lines.map(&:chomp)
      collection["items"] = Item.get_bulk(collection["item_urls"])
      # gender is added so that we can filter results according to for male and female
      # gender_flag meaning  0 = male , 1 = female , 2 = both
      collection["gender"] = params["gender_flag"]
      collection
    end

    def pushVid(bid, vid)
      bundle = _read(bid)
      if bundle
        bundle["videos"].push vid
      end
      save(bundle)
    end
    
    ## TODO make this instance method
    def removeVid(bid, vid)
      bundle = _read(bid)
      bundle["videos"].delete(vid)
      save(bundle)
    end
    
    def delete(id)
    end

    private
    def _get_next_cid
      ## TODO fix this logic. If count is zero all keys will be overwritten
      REDIS.incr(Settings.app_key + ":collectionCount").to_s
    end
    
    def _create_key(id)
      Settings.app_key + ":collection:" + id
    end

    def _read(key)
      key = _create_key(key) unless key.start_with?(Settings.app_key + ":collection:")
      collection = REDIS.get(key)
      if collection
        return ActiveSupport::JSON.decode(collection)
      end
      return nil
    end
        
    def _read_all(key)
      key = _create_key(key)
      keys = REDIS.keys(key)
      collection = []
      keys.each do |key|
        collection.push _read(key)
      end
      collection
    end
    
    def _write(key, collection)
      key = _create_key(key) unless key.start_with?(Settings.app_key + ":collection:")
      if REDIS.set(key, collection.to_json)
        Rails.logger.info "[OK] Write collection to redis"
      else
        Rails.logger.info "[FAIL] Write collection to redis"
      end
    end
  end
end