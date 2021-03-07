import 'dart:math' as math;

import 'package:malison/malison.dart';
import 'package:piecemeal/piecemeal.dart';
import 'package:speedvector7drl/src/bresenham.dart';

import 'package:speedvector7drl/src/colorscheme.dart';
import 'package:speedvector7drl/src/engine.dart';
import 'package:speedvector7drl/src/track.dart';

class Car {
  Engine _engine;
  int _char;
  Color _bodyColor;
  Color _projectionColor;
  Color _cursorColor;
  bool _crashed = false;

  final Vec _startingSpeed = Vec(0, -3);

  bool get crashed => _crashed;
  bool get isAlive => !crashed;
  bool get isWithinBounds => !engine.track.outOfBounds(pos);

  Vec _pos;
  Vec _speed;

  void bind(Engine gameEngine) {
    _engine = gameEngine;
  }

  Engine get engine => _engine;
  Track get track => engine.track;

  Car() {
    _char = CharCode.fullBlock;
    _bodyColor = ColorScheme.opponent;
    _projectionColor = ColorScheme.vProjection;
    _cursorColor = ColorScheme.vCursor;

    _speed = _startingSpeed;
  }

  void reset() {
    _crashed = false;
    updateColor(ColorScheme.opponent);
    _speed = _startingSpeed;
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
  Vec get screenPos => _pos + engine.trackScreenPosition;
  Vec get speed => _speed;
  int get absoluteSpeed => speed.y.abs();

  Vec offset(Vec relativePos) {
    return relativePos + engine.trackScreenPosition;
  }

  void park(Vec p) {
    _pos = p;
  }

  void updateSpeed(Vec m) {
    _speed += m;
  }

  void move() {
    var destination = pos + speed;
    if (obstructed(pos, destination)) {
      crash();
    }
    _pos = destination;
  }

  void crash() {
    _speed = Vec(0, 0);
    updateColor(ColorScheme.crashed);
    _crashed = true;
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

  bool obstructed(Vec origin, Vec destination) {
    for (var point in bresenham(origin, destination)) {
      if (track.isBlocked(point)) {
        return true;
      }
    }

    return false;
  }

  void render(Terminal terminal) {
    terminal.drawChar(screenPos.x, screenPos.y, char, color);
    terminal.drawChar(screenPos.x, screenPos.y + 1, char, color);
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
    if (isAlive) {
      var fgColor;
      var char;

      for (var m in mVecs) {
        var mPos = nextC(origin ?? pos) + m;
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
        if (obstructed((origin ?? pos), mPos)) {
          fgColor = ColorScheme.vProjectionWarning;
        }
        mPos = offset(mPos);
        terminal.drawChar(mPos.x, mPos.y, char, fgColor);
      }
    }
  }

  void renderDebugInfo(Terminal terminal) {
    var line = bresenham(pos, nextC());
    for (var point in line) {
      point = offset(point);
      terminal.drawChar(
          point.x, point.y, CharCode.space, Color.white, Color.darkAqua);
    }
  }
}

class Player extends Car {
  Player();

  @override
  void reset() {
    super.reset();
    updateColor(ColorScheme.player);
  }
}

class NPC extends Car {
  NPC();

  final math.Random random = math.Random();

  bool get goingLeft => speed.x < 0;
  bool get goingRight => speed.x > 0;

  void veerRight() {
    updateSpeed(Vec(1, 0));
  }

  void veerLeft() {
    updateSpeed(Vec(-1, 0));
  }

  void hardRight() {
    updateSpeed(Vec(1, 1));
  }

  void hardLeft() {
    updateSpeed(Vec(-1, 1));
  }

  void update(int speed) {
    if (isAlive) {
      tryToStayOnTheRoad();
    }
  }

  void tryToStayOnTheRoad() {
    adjustHeading();
  }

  void adjustHeading() {
    var clearLeft = !obstructed(pos, nextC() + Vec(-5, 0));
    var clearRight = !obstructed(pos, nextC() + Vec(5, 0));

    if (clearLeft && clearRight) {
      if (random.nextBool()) {
        updateSpeed(Vec(0, -1));
      }
    } else if (!clearLeft && !clearRight) {
      updateSpeed(Vec(0, 1));
    } else if (clearLeft && !clearRight) {
      veerLeft();
    } else if (!clearLeft && clearRight) {
      veerRight();
    }
  }
}
