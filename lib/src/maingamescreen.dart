import 'package:malison/malison.dart';
import 'package:malison/malison_web.dart';
import 'package:piecemeal/piecemeal.dart';
import 'package:speedvector7drl/src/car.dart';
import 'package:speedvector7drl/src/engine.dart';
import 'package:speedvector7drl/src/track.dart';

class MainGameScreen extends Screen<String> {
  final Engine engine;

  MainGameScreen(this.engine);

  Player get player => engine.player;
  Track get track => engine.track;

  bool _displayHint = false;
  bool _displayGrid = false;
  bool _debug = false;

  Vec cursor = Vec(0, 0);
  List<Vec> mSpots = List.of([
    Vec(-1, -1),
    Vec(0, -1),
    Vec(1, -1),
    Vec(-1, 0),
    Vec(0, 0),
    Vec(1, 0),
    Vec(-1, 1),
    Vec(0, 1),
    Vec(1, 1),
  ]);
  bool _confirmed = false;

  bool get inputConfirmed => _confirmed;

  void confirmInput() {
    _confirmed = true;
  }

  void resetInput() {
    _confirmed = false;
  }

  void moveCursor(Vec m) {
    cursor += m;
    if (cursor.x < -1) {
      cursor = Vec(-1, cursor.y);
    }
    if (cursor.x > 1) {
      cursor = Vec(1, cursor.y);
    }
    if (cursor.y < -1) {
      cursor = Vec(cursor.x, -1);
    }
    if (cursor.y > 1) {
      cursor = Vec(cursor.x, 1);
    }
  }

  @override
  bool handleInput(String input) {
    switch (input) {
      case 'n':
        moveCursor(Vec(0, -1));
        break;

      case 's':
        moveCursor(Vec(0, 1));
        break;

      case 'e':
        moveCursor(Vec(1, 0));
        break;

      case 'w':
        moveCursor(Vec(-1, 0));
        break;

      case 'confirm':
        player.updateSpeed(cursor);
        confirmInput();
        break;

      case 'space':
        cursor = Vec(0, 0);
        confirmInput();
        break;

      case 'comma':
        _displayHint = !_displayHint;
        break;

      case 'period':
        _displayGrid = !_displayGrid;
        break;

      case 'debug':
        _debug = !_debug;
        break;

      default:
        return false;
    }

    dirty();
    ui.refresh();

    return true;
  }

  @override
  void update() {
    if (inputConfirmed) {
      engine.update();
      resetInput();
    }
  }

  @override
  void render(Terminal terminal) {
    terminal.clear();

    engine.track
        .render(terminal, 25, 2, showGrid: _displayGrid, debugMode: _debug);
    renderScore(terminal);

    if (_debug) {
      player.renderDebugInfo(terminal);
    }

    if (engine.npcs.isNotEmpty) {
      for (var npc in engine.npcs) {
        if (_debug) {
          npc.renderDebugInfo(terminal);
        }
        if (npc.isWithinBounds) {
          npc.render(terminal);
        }
      }
    }

    player.renderProjectedMoves(terminal, cursor, showHint: _displayHint);
    if (player.isWithinBounds) {
      player.render(terminal);
    }
  }

  void renderScore(Terminal terminal) {
    var x = engine.trackScreenPosition.x + track.width + 3;
    var y = 3;

    terminal.writeAt(x, y, 'Hi-score: ${engine.highscore}');

    y += 2;

    terminal.writeAt(x, y, 'Score: ${engine.score}');
  }
}
