class Game
  class << self
    def start(uuid1, uuid2)
      white, black = [uuid1, uuid2].shuffle

      ActionCable.server.broadcast "player_#{white}", {action: "game_start", msg: "white"}
      ActionCable.server.broadcast "player_#{black}", {action: "game_start", msg: "black"}

      REDIS.set("opponent_for:#{white}", black)
      REDIS.set("opponent_for:#{black}", white)
    end

    def forfeit(uuid)
      if winner = opponent_for(uuid)
        ActionCable.server.broadcast "player_#{winner}", {action: "opponent_forfeits"}
      end
    end

    def opponent_for(uuid)
      REDIS.get("opponent_for:#{uuid}")
    end

    def make_move(uuid, data)
      opponent = opponent_for(uuid)
      move_string = "#{data["from"]}-#{data["to"]}"

      ActionCable.server.broadcast "player_#{opponent}", {action: "make_move", msg: move_string}
    end

    def game_over uuid
      opponent = opponent_for uuid
      ActionCable.server.broadcast "player_#{opponent}", {action: "game_over", msg: "You lose!"}
    end
  end
end
