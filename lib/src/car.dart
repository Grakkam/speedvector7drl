import 'package:malison/malison.dart';
import 'package:piecemeal/piecemeal.dart';

import 'package:speedvector7drl/src/colorscheme.dart';
import 'package:speedvector7drl/src/engine.dart';

class Car {
  Engine _engine;
  int _char;
  Color _bodyColor;
  Color _projectionColor;
  Color _cursorColor;

  Vec _pos;
  Vec _speed;

  void bind(Engine gameEngine) {
    _engine = gameEngine;
  }

  Engine get engine => _engine;

  Car() {
    _char = CharCode.fullBlock;
    _bodyColor = ColorScheme.carBody;
    _projectionColor = ColorScheme.vProjection;
    _cursorColor = ColorScheme.vCursor;

    _speed = Vec(0, 0);
  }

  List<Vec> mVecs = List.of([
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

  int get char => _char;
  Color get color => _bodyColor;
  Vec get pos => _pos;
  Vec get screenPos => _pos + engine.trackPosition;
  Vec get speed => _speed;

  Vec offset(Vec relativePos) {
    return relativePos + engine.trackPosition;
  }

  void park(int x, int y) {
    _pos = Vec(x, y);
  }

  void updateSpeed(Vec m) {
    _speed += m;
  }

  void move() {
    _pos += _speed;
  }

  void rollDown() {
    _pos += Vec(0, 1);
  }

  void updateColor(Color color) {
    _bodyColor = color;
  }

  Vec nextC([Vec origin]) {
    var p = origin ?? pos;
    return p + speed;
  }

  void render(Terminal terminal) {
    terminal.drawChar(screenPos.x, screenPos.y, char, color);
  }

  void renderNextC(Terminal terminal, [Vec origin]) {
    var fgColor = _projectionColor;
    var mpos = (origin ?? pos) + speed;
    terminal.drawChar(mpos.x, mpos.y, CharCode.plus, fgColor);
  }

  void renderHint(Terminal terminal, Vec m, {Vec origin}) {
    var fgColor = _projectionColor;
    var p = (origin ?? pos) + speed + m;
    terminal.drawChar(p.x, p.y, CharCode.plus, fgColor);
  }

  void renderProjectedMoves(Terminal terminal, Vec cursorPos,
      {Vec origin, bool showHint = false}) {
    var fgColor;
    var char;
    for (var m in mVecs) {
      if (cursorPos != null && m == cursorPos) {
        fgColor = _cursorColor;
        char = CharCode.plus;
        if (showHint) {
          renderHint(terminal, m, origin: offset(nextC() + m));
        }
      } else {
        fgColor = _projectionColor;
        char = CharCode.middleDot;
      }
      var mPos = nextC(origin ?? pos) + m;
      if (engine.track.isBlocked(mPos.x, mPos.y)) {
        fgColor = ColorScheme.vProjectionWarning;
      }
      mPos = offset(mPos);
      terminal.drawChar(mPos.x, mPos.y, char, fgColor);
    }
  }
}
