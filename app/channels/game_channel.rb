class GameChannel < ApplicationCable::Channel

  def subscribed
    stream_from "player_#{current_user.id}"
    ChessBoard.find_opponent_for current_user.id.to_s
  end

  def unsubscribed
    @game_board = ChessBoard.find_by_id(1)
    @game_board.forfeit current_user.id
  end

  def make_move data
    @game_board = ChessBoard.find_by_id(1)
    @game_board.make_move current_user.id, data
  end

  def game_over data
    @game_board = ChessBoard.find_by_id(1)
    @game_board.game_over current_user.id, data
  end
end
