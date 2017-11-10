$(function() {
  if($("#game-play").length > 0) {
            debugger;
    App.game = App.cable.subscriptions.create("GameChannel", {
      connected: function() {
        return this.printMessage("Waiting for opponent...");
      },
      received: function(data) {
        var ref, source, target;
        switch (data.action) {
          case "game_start":
            App.board.position("start");
            App.board.orientation(data.msg);
            return this.printMessage("Game started! You play as " + data.msg + ".");
          case "make_move":
            ref = data.msg.split("-"), source = ref[0], target = ref[1];
            App.chess.move({
              from: source,
              to: target,
              promotion: "q"
            });
            return App.board.position(App.chess.fen());
          case "opponent_forfeits":
            this.unsubscribe();
            return this.printMessage("Opponent forfeits. You win!");
          case "game_over":
            this.printMessage(data.msg);
            return this.unsubscribe();
        }
      },
      printMessage: function(message) {
        $("#messages").empty();
        return $("#messages").append("<p>" + message + "</p>");
      }
    });
  } else if(App.game) {
    App.game.unsubscribe();
    App.game = null;
  }
});
