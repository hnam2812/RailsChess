App.game = App.cable.subscriptions.create("GameChannel", {
  connected: function() {
    return this.printMessage("Waiting for opponent", "wait-opponent");
  },
  received: function(data) {
    var ref, source, target;
    switch (data.action) {
      case "game_start":
        App.board.position("start");
        App.board.orientation(data.msg);
        return this.printMessage("Game started! You play as " + data.msg + ".", "notice");
      case "make_move":
        ref = data.move.split("-"), source = ref[0], target = ref[1];
        App.chess.move({
          from: source,
          to: target,
          promotion: "q"
        });
        this.printMessage(data.msg, data.type);
        return App.board.position(App.chess.fen());
      case "opponent_forfeits":
        return this.printMessage(data.msg, data.type);
      case "game_over":
        return this.printMessage(data.msg, data.type);
    }
  },
  printMessage: function(message, type) {
    if(type === "wait-opponent" && $("#game-status").children().length === 0) {
      $("#game-status").append("<p class=" + type + ">" + message + "</p>");
    }
    if (type !== "wait-opponent"){
      $("#game-status").empty();
      $("#game-status").append("<p class=" + type + ">" + message + "</p>");
    }
  }
});
