import 'dart:html' as html;
import 'package:malison/malison.dart';
import 'package:piecemeal/piecemeal.dart';
import 'package:speedvector7drl/src/aboutscreen.dart';
import 'package:speedvector7drl/src/game.dart';
import 'package:speedvector7drl/src/howtoplayscreen.dart';
import 'package:speedvector7drl/src/loghistoryscreen.dart';
import 'package:speedvector7drl/src/maingamescreen.dart';
import 'package:speedvector7drl/src/ui.dart';

class MainMenuScreen extends ScreenWithMouse<String> {
  final Game _game;

  Game get game => _game;

  int choice = 0;
  List<String> options = [
    'New Game',
    'How to Play',
    'About the Game',
    'View Log History'
  ];
  List<Button> buttons = [];

  MainMenuScreen(this._game) {
    var buttonX = 8;
    var buttonY = 12;
    for (var text in options) {
      buttons
          .add(Button(Vec(buttonX, buttonY), text, Color.darkAqua, Color.aqua));
      buttonY += 2;
    }
  }

  @override
  bool keyDown(int keyCode, {bool shift, bool alt}) {
    if (keyCode == KeyCode.up || keyCode == KeyCode.numpad8) {
      updateChoice(-1);
    } else if (keyCode == KeyCode.down || keyCode == KeyCode.numpad2) {
      updateChoice(1);
    } else if (keyCode == KeyCode.enter ||
        keyCode == KeyCode.numpadEnter ||
        keyCode == KeyCode.numpad5) {
      confirmChoice();
    }

    dirty();

    return false;
  }

  @override
  bool mouseUp(html.MouseEvent mouseEvent) {
    for (var i = 0; i < buttons.length; i++) {
      if (buttons[i].hoveredOver(mousePosition16)) {
        choice = i;
        confirmChoice();
      }
    }
    return true;
  }

  @override
  bool mouseMove(html.MouseEvent mouseEvent) {
    for (var i = 0; i < buttons.length; i++) {
      if (buttons[i].hoveredOver(mousePosition16)) {
        choice = i;
      }
    }
    dirty();
    return true;
  }

  void updateChoice(int amount) {
    choice += amount;
    if (choice < 0) {
      choice = 0;
    }
    if (choice > options.length - 1) {
      choice = options.length - 1;
    }
  }

  void confirmChoice() {
    switch (choice) {
      case 0:
        ui.push(MainGameScreen(game));
        break;
      case 1:
        ui.push(HowToPlayScreen(game, options[choice]));
        break;
      case 2:
        ui.push(AboutScreen(game, options[choice]));
        break;
      case 3:
        ui.push(MessageLogScreen(game, options[choice]));
        break;
      default:
    }

    return;
  }

  @override
  void render(Terminal terminal) {
    for (var i = 0; i < options.length; i++) {
      buttons[i].render(terminal, (choice == i));
    }

    if (game.highscore > 0) {
      var x = terminal.width ~/ 2;
      var y = 8;
      terminal.writeAt(x, y, 'Highest Score:');
      terminal.writeAt(x + 3, y += 2, game.highscore.toString(), Color.purple);
      terminal.writeAt(x, y += 2, 'Death Count:');
      terminal.writeAt(x + 3, y += 2, game.deathCount.toString(), Color.purple);
      terminal.writeAt(x, y += 2, 'Longest game:');
      terminal.writeAt(
          x + 3, y += 2, '${game.longestGame.toString()} turns', Color.purple);
    }

    game.messageLog.render(terminal, game.logPanelPosition.x,
        game.logPanelPosition.y, game.logPanelSize.x, game.logPanelSize.y);
  }
}
