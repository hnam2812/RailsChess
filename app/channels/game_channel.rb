class GameChannel < ApplicationCable::Channel
  def subscribed
    stream_from "player_#{current_user.id}"
    Seek.create current_user.id.to_s
  end

  def unsubscribed
    Game.forfeit current_user.id
    Seek.remove current_user.id
  end

  def make_move data
    Game.make_move current_user.id, data
  end

  def game_over
    Game.game_over current_user.id
  end
end
