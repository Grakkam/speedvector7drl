import 'dart:math' as math;

import 'package:malison/malison.dart';
import 'package:piecemeal/piecemeal.dart';
import 'package:speedvector7drl/src/colorscheme.dart';

class Track {
  final int _width;
  final int _height;
  List<String> _road;
  int _roadWidth;
  int _roadOffset;
  String _topRow;
  final math.Random _random = math.Random();

  int get width => _width;
  int get height => _height;
  bool get randomBool => _random.nextBool();
  int randomInt(int min, int max) {
    return _random.nextInt(max) + min;
  }

  Track(this._width, this._height) {
    initialize();
  }

  void initialize() {
    _roadWidth = width - 6;
    _roadOffset = 3;
    var char;
    var row = '';

    for (var x = 0; x < width; x++) {
      if (x < _roadOffset || x > (_roadOffset + _roadWidth - 1)) {
        char = '#';
      } else {
        char = '.';
      }

      row += char;
    }

    _road = List.filled(height, row, growable: true);
    stashTopRow();
  }

  void stashTopRow() {
    _topRow = _road[0];
  }

  void rollDown() {
    stashTopRow();
    _road.insert(0, _topRow); // TODO: generate new row!
    _road.removeLast();
  }

  bool outOfBounds(Vec p) {
    return p.x < 0 || p.x > width - 1 || p.y < 0 || p.y > height - 1;
  }

  bool isBlocked(int x, int y) {
    return ((outOfBounds(Vec(x, y))) || _road[y][x] == '#');
  }

  void render(Terminal terminal, int xPos, int yPos, {bool showGrid = false}) {
    for (var x = 0; x < width; x++) {
      for (var y = 0; y < height; y++) {
        if (showGrid) {
          terminal.drawChar(
              xPos + x, yPos + y, CharCode.middleDot, ColorScheme.openGround);
        }
        if (_road[y][x] == '#') {
          terminal.drawChar(
              xPos + x, yPos + y, CharCode.lightShade, ColorScheme.roughGround);
        }
      }
    }
  }
}
