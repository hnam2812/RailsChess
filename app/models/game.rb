class Game
  class << self
    def start user, opponent_user
      white, black = [user, opponent_user].shuffle
      ActionCable.server.broadcast "player_#{white}",
        {action: "game_start", msg: "white"}
      ActionCable.server.broadcast "player_#{black}",
        {action: "game_start", msg: "black"}

      REDIS.set("opponent_for:#{white}", black)
      REDIS.set("opponent_for:#{black}", white)
    end

    def forfeit user
      if winner = opponent_for(user)
        ActionCable.server.broadcast "player_#{winner}",
          {action: "opponent_forfeits", msg: "Opponent disconnected, you win!"}
      end
    end

    def opponent_for user
      REDIS.get("opponent_for:#{user}")
    end

    def make_move user, data
      opponent = opponent_for user
      move_string = "#{data["move"]["from"]}-#{data["move"]["to"]}"
      status = data["status"].split("-")[0]
      type = data["status"].split("-")[1]
      ActionCable.server.broadcast "player_#{opponent}",
        {action: "make_move", move: move_string, msg: status, type: type}
    end

    def game_over user
      opponent = opponent_for user
      ActionCable.server.broadcast "player_#{opponent}",
        {action: "game_over", msg: "You lose!"}
    end
  end
end
