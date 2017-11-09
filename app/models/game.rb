class Game
  class << self
    def start user, opponent_user
      white, black = [user, opponent_user].shuffle
      ActionCable.server.broadcast "player_#{white}", {action: "game_start", msg: "white"}
      ActionCable.server.broadcast "player_#{black}", {action: "game_start", msg: "black"}

      REDIS.set("opponent_for:#{white}", black)
      REDIS.set("opponent_for:#{black}", white)
    end

    def forfeit user
      if winner = opponent_for(user)
        ActionCable.server.broadcast "player_#{winner}", {action: "opponent_forfeits"}
      end
    end

    def opponent_for user
      REDIS.get("opponent_for:#{user}")
    end

    def make_move user, data
      opponent = opponent_for user
      move_string = "#{data["from"]}-#{data["to"]}"

      ActionCable.server.broadcast "player_#{opponent}", {action: "make_move", msg: move_string}
    end

    def game_over uuid
      opponent = opponent_for user
      ActionCable.server.broadcast "player_#{opponent}", {action: "game_over", msg: "You lose!"}
    end
  end
end
