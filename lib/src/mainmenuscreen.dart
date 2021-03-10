import 'package:malison/malison.dart';
import 'package:malison/malison_web.dart';
import 'package:speedvector7drl/src/game.dart';
import 'package:speedvector7drl/src/instructionsscreen.dart';
import 'package:speedvector7drl/src/maingamescreen.dart';
import 'package:speedvector7drl/src/renderfunctions.dart';

class MainMenuScreen extends Screen<String> {
  final Game _game;
  int cursor = 0;
  List<String> options = ['New Game', 'How to Play'];

  MainMenuScreen(this._game);

  Game get game => _game;
  @override
  bool keyDown(int keyCode, {bool shift, bool alt}) {
    if (keyCode == KeyCode.up || keyCode == KeyCode.numpad8) {
      moveCursor(-1);
    } else if (keyCode == KeyCode.down || keyCode == KeyCode.numpad2) {
      moveCursor(1);
    } else if (keyCode == KeyCode.enter || keyCode == KeyCode.numpadEnter) {
      confirmChoice(cursor);
    }

    dirty();

    return false;
  }

  @override
  void render(Terminal terminal) {
    var x = 4;
    var y = 4;
    terminal.writeAt(x, y, 'SPEED VECTOR', Color.purple);
    terminal.writeAt(x + 3, y += 2,
        'a fast-paced, turn-based, arcade racing roguelike', Color.gray);
    terminal.writeAt(
        x, y += 3, '7DRL 2021 Edition --- v.${game.version}', Color.darkGold);
    terminal.writeAt(x + 3, y += 2, 'by u/Grakkam', Color.gray);

    x = 8;
    y += 5;
    for (var i = 0; i < options.length; i++) {
      renderButton(terminal, x, y + i * 3, options[i], selected: (cursor == i));
    }
  }

  void moveCursor(int amount) {
    cursor += amount;
    if (cursor < 0) {
      cursor = 0;
    }
    if (cursor > options.length - 1) {
      cursor = options.length - 1;
    }
  }

  void confirmChoice(int choice) {
    switch (choice) {
      case 0:
        ui.push(MainGameScreen(game));
        break;
      case 1:
        ui.push(InstructionsScreen(_game));
        break;
      case 2:
      default:
    }

    return;
  }
}
