import 'dart:math' as math;

import 'package:malison/malison.dart';
import 'package:piecemeal/piecemeal.dart';
import 'package:speedvector7drl/src/bresenham.dart';
import 'package:speedvector7drl/src/game.dart';
import 'package:speedvector7drl/src/track.dart';

class Entity {
  final Game _game;
  String name;
  int charCode;
  Vec position;
  Color fgColor;
  Color bgColor;
  bool blocksMovement;
  // TODO: Render order

  Entity(this._game, this.position, this.name, this.charCode, this.fgColor,
      this.bgColor, this.blocksMovement);

  Game get game => _game;
  Track get track => game.track;
  Vec get screenCoordinates => position + game.trackPanelPosition;

  void rollDown([int amount = 1]) {
    for (var i = 0; i < amount; i++) {
      position += Direction.s;
    }
  }

  void update() {}

  @override
  String toString() => name;

  void renderToDisplay(Terminal terminal, Vec pos, int charCode,
      {Color fgColor = Color.white, Color bgColor = Color.black}) {
    pos += game.trackPanelPosition;
    terminal.drawChar(pos.x, pos.y, charCode, fgColor, bgColor);
  }

  void render(Terminal terminal) {
    renderToDisplay(terminal, position, charCode,
        fgColor: fgColor, bgColor: bgColor);
  }
}

class Car extends Entity {
  Color projectionColor = Color.gray;
  Color cursorColor = Color.white;
  Vec speedVector;
  Vec startingSpeedVector = Vec(0, -3);
  bool crashed = false;
  List standardDirectionVectors = <Direction>[];

  Car(Game game, Vec position, String name, Color fgColor, Color bgColor)
      : super(game, position, name, CharCode.greekSmallLetterTau, fgColor,
            bgColor, true) {
    speedVector = startingSpeedVector;
    standardDirectionVectors.addAll(Direction.all);
    standardDirectionVectors.add(Direction.none);
  }

  bool get isAlive => !crashed;
  int get speed => speedVector.y.abs();
  bool get movingLeft => speedVector.x < 0;
  bool get movingRight => speedVector.x > 0;

  Vec get forwardSensor => nextC(nextC(nextC(nextC())));
  Vec get rightSensor => nextC() + Vec(6, -3);
  Vec get leftSensor => nextC() + Vec(-6, -3);

  void changeSpeed(Direction direction) {
    speedVector += direction;
  }

  void move() {
    var destination = position + speedVector;
    if (pathIsObstructed(position, destination) ||
        game.entityAtPosition(destination) != null) {
      crash();
    }
    position = destination;
  }

  void crash() {
    crashed = true;
    speedVector = Vec(0, 0);
  }

  void reset(Vec pos) {
    position = pos;
    crashed = false;
    speedVector = startingSpeedVector;
  }

  Vec nextC([Vec origin]) {
    var p = origin ?? position;
    return p + speedVector;
  }

  bool pathIsObstructed(Vec origin, Vec destination) {
    for (var point in bresenham(origin, destination)) {
      if (track.isBlocked(point)) {
        return true;
      }
    }

    return false;
  }

  void renderProjectedMoves(Terminal terminal,
      {Vec cursorPos, Vec origin, bool showHint = false}) {
    var pos = origin ?? position;
    var c = nextC(pos);

    if (isAlive) {
      var fgColor;
      var charCode;

      for (var dVec in standardDirectionVectors) {
        var point = c + dVec;
        if (cursorPos != null &&
            dVec.x == cursorPos.x &&
            dVec.y == cursorPos.y) {
          fgColor = cursorColor;
          charCode = CharCode.plus;
          if (showHint) {
            renderToDisplay(terminal, nextC(point), CharCode.plus,
                fgColor: Color.darkGray);
          }
        } else {
          fgColor = projectionColor;
          charCode = CharCode.middleDot;
        }
        if (pathIsObstructed(position, point)) {
          fgColor = Color.red;
        }

        renderToDisplay(terminal, point, charCode, fgColor: fgColor);
      }
    }
  }

  void renderDebugInfo(Terminal terminal) {
    // var line = bresenham(position, nextC());
    // for (var point in line) {
    //   renderToDisplay(terminal, point, CharCode.space, bgColor: Color.orange);
    // }
    var points = [];
    points.add(forwardSensor);
    points.add(nextC(nextC()));
    points.add(leftSensor);
    points.add(rightSensor);
    for (var point in points) {
      renderToDisplay(terminal, point, CharCode.plus, fgColor: fgColor);
    }
  }

  @override
  void render(Terminal terminal) {
    if (isAlive && !track.outOfBounds(position)) {
      renderToDisplay(terminal, position, charCode,
          fgColor: fgColor, bgColor: bgColor);
    } else if (!track.outOfBounds(position)) {
      renderToDisplay(terminal, position, CharCode.lowerHalfBlock,
          fgColor: Color.darkRed);
    }
  }
}

class PlayerCar extends Car {
  PlayerCar(Game game, Vec position,
      {Color fgColor = Color.purple, Color bgColor = Color.black})
      : super(game, position, 'Player', fgColor, bgColor);
}

class NPC extends Car {
  NPC(Game game, Vec position,
      {Color fgColor = Color.darkYellow, Color bgColor = Color.black})
      : super(game, position, 'NPC', fgColor, bgColor);

  final math.Random random = math.Random();

  bool get goingLeft => speedVector.x < 0;
  bool get goingRight => speedVector.x > 0;

  void veerRight() {
    changeSpeed(Direction.e);
  }

  void veerLeft() {
    changeSpeed(Direction.w);
  }

  void hardRight() {
    changeSpeed(Direction.se);
  }

  void hardLeft() {
    changeSpeed(Direction.sw);
  }

  void speedUp() {
    changeSpeed(Direction.n);
  }

  void slowDown() {
    changeSpeed(Direction.s);
  }

  @override
  void update() {
    if (isAlive) {
      tryToStayOnTheRoad();
    }
  }

  void tryToStayOnTheRoad() {
    adjustHeading();
  }

  void adjustHeading() {
    var clearLeft = !pathIsObstructed(position, leftSensor);
    var clearRight = !pathIsObstructed(position, rightSensor);
    var clearAhead = !pathIsObstructed(position, forwardSensor);

    if (clearAhead && speed < game.roadMaxSpeed) {
      speedUp();
    } else if (!clearLeft && !clearRight && !clearAhead && speed > 2) {
      slowDown();
    } else if (clearAhead && !clearLeft && clearRight) {
      veerRight();
    } else if (clearAhead && clearLeft && !clearRight) {
      veerLeft();
    } else if (!clearAhead && !clearLeft && clearRight) {
      hardRight();
    } else if (!clearAhead && clearLeft && !clearRight) {
      hardLeft();
    }
  }
}
