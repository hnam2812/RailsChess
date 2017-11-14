class ChessBoard < ActiveRecord::Base
  belongs_to :opponent, class_name: User.name, foreign_key: :opponent_id
  belongs_to :owner_board, class_name: User.name, foreign_key: :owner_board_id

  # validates :moves_arr, presence: true

  enum owner_board_color: {black: BLACK, white: WHITE}
  enum board_status: {in_game: 1, draw: 2, finished: 3}

  scope :find_playing_board, -> user_id do
    opponent_id = opponent_for user_id
    where(board_status: :in_game).where("owner_board_id = ? AND opponent_id = ?
      OR owner_board_id = ? AND opponent_id = ?", user_id, opponent_id, opponent_id, user_id).last
  end

  class << self
    def find_opponent_for user
      if opponent = REDIS.spop("seeks")
        if opponent != user
          owner_board_color = [WHITE, BLACK].shuffle.first
          board = ChessBoard.create!(owner_board_id: user,
            opponent_id: opponent, owner_board_color: owner_board_color,
            board_status: :in_game, moves_arr: "[]")
          board.start
        end
      else
        REDIS.sadd("seeks", user)
      end
    end
  end

  def start
    ActionCable.server.broadcast "player_#{self.owner_board_id}",
      {action: "game_start", msg: "#{self.owner_board_color}"}
    ActionCable.server.broadcast "player_#{self.opponent_id}",
      {action: "game_start", msg: "#{self.opponent_board_color}"}
  end

  def forfeit user
    if winner = opponent_for(user)
      if self.update_attributes board_status: :finished, winner_id: winner
        ActionCable.server.broadcast "player_#{winner}",
          {action: "opponent_forfeits", msg: "Opponent disconnected, you win!", type: "game-over"}
      end
    end
  end

  def opponent_for user
    return opponent_id if user == owner_board_id
    owner_board_id
  end

  def make_move user, data
    game = Chess::Game.new game: YAML.load(moves_arr)
    move_string = "#{data["move"]["from"]}#{data["move"]["to"]}"
    if !game.full_move move_string
      opponent = opponent_for user
      status = data["status"].split("-")[0]
      type = data["status"].split("-")[1]
      move_string = "#{data["move"]["from"]}-#{data["move"]["to"]}"
      self.update_attribute :moves_arr, game.moves.to_s
      ActionCable.server.broadcast "player_#{opponent}",
        {action: "make_move", move: move_string, msg: status, type: type}
    end
  end

  def game_over user, data
    opponent = opponent_for user
    status = data["status"].split("-")[0]
    type = data["status"].split("-")[1]
    winner = data["type"] == "checkmate" ? user : nil
    if self.update_attributes board_status: :finished, winner_id: winner
      ActionCable.server.broadcast "player_#{opponent}",
        {action: "game_over", msg: status, type: type}
    end
  end

  def opponent_board_color
    white? ? BLACK : WHITE
  end
end
