$(function() {
  if($("#game-play").length > 0) {
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

function onDragStart(source, piece, position, orientation) {
  return !(App.chess.game_over() ||
    (App.chess.turn() === "w" && piece.search(/^b/) !== -1) ||
    (App.chess.turn() === "b" && piece.search(/^w/) !== -1) ||
    (orientation === "white" && piece.search(/^b/) !== -1) ||
    (orientation === "black" && piece.search(/^w/) !== -1));
}

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
    App.game.perform("make_move", move);
    App.board.position(App.chess.fen(), false);
  }

  if(App.chess.game_over()){
    App.game.perform("game_over");
    $("#messages").empty();
    return $("#messages").append("<p>" + "You win!" + "</p>");
  }
}
