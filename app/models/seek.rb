class Seek
  class << self
    def create(uuid)
      if opponent = REDIS.spop("seeks")
        Game.start(uuid, opponent)
      else
        REDIS.sadd("seeks", uuid)
      end
    end

    def remove(uuid)
      REDIS.srem("seeks", uuid)
    end

    def clear_all
      REDIS.del("seeks")
    end
  end
end
