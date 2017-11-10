$(function() {
  if($("#game-play").length === 0 && App.game) {
    App.game.unsubscribe();
    App.game = null;
  }

  if($("#game-play").length > 0){
    var cfg;
    App.chess = new Chess();
    cfg = {
      draggable: true,
      pieceTheme: "assets/chesspieces/alpha/{piece}.png",
      showNotation: false,
      onDragStart: onDragStart,
      onDrop: onDrop
    };
    return App.board = ChessBoard("chessboard", cfg);
  }
});

  function gameStatus(){
    var your_status = "Opponent turn";;
    var opponent_status = "Your turn";
    var type = "notice";
    // check?
    if (App.chess.in_check() === true) {
      your_status += ", " + "You checking";
      opponent_status += ", " + "You are in check";
      type = "warning";
    }

    // checkmate?
    if (App.chess.in_checkmate() === true) {
      your_status = status = "You win, opponent is in checkmate.";
      opponent_status = "Game over, you are in checkmate";
      type = "game-over";
    }
    // draw?
    if (App.chess.in_draw() === true) {
      your_status = opponent_status = "Game over, drawn position";
      type = "game-over";
    }

    return [your_status, opponent_status, type];
  };

  function printMessage(message, type) {
    return $("#game-status").empty().append("<p class=" + type + ">" + message + "</p>");
  };

  function onDragStart(source, piece, position, orientation) {
    return !(App.chess.game_over() ||
      (App.chess.turn() === "w" && piece.search(/^b/) !== -1) ||
      (App.chess.turn() === "b" && piece.search(/^w/) !== -1) ||
      (orientation === "white" && piece.search(/^b/) !== -1) ||
      (orientation === "black" && piece.search(/^w/) !== -1));
  };

  function onDrop(source, target) {
    var move;
    move = App.chess.move({
      from: source,
      to: target,
      promotion: "q"
    });

    if (move === null) {
      return "snapback";
    } else {
      App.board.position(App.chess.fen(), false);
      var status = gameStatus();
      printMessage(status[0], status[2])
      App.game.perform("make_move", {move: move, status: [status[1], status[2]].join("-")});
      if (App.chess.game_over()){
        App.game.perform("game_over");
      }
    }
  };
