class CreateChessBoards < ActiveRecord::Migration[5.0]
  def change
    create_table :chess_boards do |t|
      t.integer  :owner_board_id
      t.integer :opponent_id
      t.string   :fen
      t.string   :moves_arr
      t.string :owner_board_color
      t.integer :board_status
      t.integer :winner_id

      t.timestamps null: false
    end
  end
end
