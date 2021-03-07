import 'dart:math' as math;

import 'package:malison/malison.dart';
import 'package:malison/malison_web.dart';
import 'package:piecemeal/piecemeal.dart';
import 'package:speedvector7drl/src/car.dart';
import 'package:speedvector7drl/src/engine.dart';
import 'package:speedvector7drl/src/track.dart';

class MainGameScreen extends Screen<String> {
  final Engine engine;

  MainGameScreen(this.engine);

  Car get car => engine.car;
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
        car.updateSpeed(cursor);
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
      track.update();
      var speed = math.min(math.max(car.speed.y.abs(), engine.roadLowSpeed),
          engine.roadHighSpeed);
      for (var i = 0; i < speed; i++) {
        track.rollDown();
        car.rollDown();
      }
      car.move();
      resetInput();
    }
  }

  @override
  void render(Terminal terminal) {
    terminal.clear();

    engine.track
        .render(terminal, 25, 2, showGrid: _displayGrid, debugMode: _debug);

    if (_debug) {
      car.renderDebugInfo(terminal);
    }
    car.renderProjectedMoves(terminal, cursor, showHint: _displayHint);
    car.render(terminal);
  }
}
