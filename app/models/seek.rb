class Seek
  class << self
    def create user
      if opponent = REDIS.spop("seeks")
        Game.start user, opponent if opponent != user
      else
        REDIS.sadd("seeks", user)
      end
    end

    def remove user
      opponent = Game.opponent_for user
      REDIS.del("opponent_for:#{user}")
      REDIS.del("opponent_for:#{opponent}")
      REDIS.srem("seeks", user)
    end

    def clear_all
      REDIS.del("seeks")
    end
  end
end
