class GameChannel < ApplicationCable::Channel
  def subscribed
    stream_from "player_#{current_user.id}"
  end

  def unsubscribed
    Seek.remove current_user.id
    Game.forfeit current_user.id
  end

  def make_move data
    Game.make_move current_user.id, data
  end

  def game_over
    Game.game_over current_user.id
  end
end
