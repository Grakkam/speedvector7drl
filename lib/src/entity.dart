import 'dart:math' as math;

import 'package:malison/malison.dart';
import 'package:piecemeal/piecemeal.dart';
import 'package:speedvector7drl/src/bresenham.dart';
import 'package:speedvector7drl/src/colorscheme.dart';
import 'package:speedvector7drl/src/game.dart';
import 'package:speedvector7drl/src/linearfunctions.dart';
import 'package:speedvector7drl/src/track.dart';

class Entity {
  final Game _game;
  String name;
  int charCode;
  Vec position;
  Vec lastPosition;
  Color fgColor;
  Color bgColor;
  bool blocksMovement;
  // TODO: Render order

  Entity(this._game, this.position, this.name, this.charCode, this.fgColor,
      this.bgColor, this.blocksMovement) {
    lastPosition = Vec(0, 0);
  }

  Game get game => _game;
  Track get track => game.track;
  Vec get screenCoordinates => position + game.trackPanelPosition;

  void update() {}

  void rollDown([int amount = 1]) {
    for (var i = 0; i < amount; i++) {
      position += Direction.s;
      lastPosition += Direction.s;
    }
  }

  @override
  String toString() => name;

  void updatePosition(Vec pos) {
    lastPosition = Vec(position.x, position.y);
    position = Vec(pos.x, pos.y);
  }

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
  int maxHp;
  int hp;
  Color projectionColor = ColorScheme.projectionVec;
  Color cursorColor = ColorScheme.projectionCursor;
  Vec speedVector;
  Vec startingSpeedVector = Vec(0, -3);
  bool wrecked = false;
  List standardDirectionVectors = <Direction>[];

  Car(Game game, Vec position, String name, Color fgColor, Color bgColor)
      : super(game, position, name, CharCode.greekSmallLetterTau, fgColor,
            bgColor, true) {
    speedVector = startingSpeedVector;
    standardDirectionVectors.addAll(Direction.all);
    standardDirectionVectors.add(Direction.none);
  }

  bool get isAlive => !wrecked;
  int get topSpeed => game.roadMaxSpeed + 1;
  int get speed => speedVector.abs().y;
  Direction get directionVector => speedVector.nearestDirection;
  bool get movingLeft => speedVector.x < 0;
  bool get movingRight => speedVector.x > 0;

  Vec get forwardSensor => nextC(nextC(nextC(nextC())));
  Vec get rightSensor => nextC() + Vec(6, -3);
  Vec get leftSensor => nextC() + Vec(-6, -3);

  Vec get destination => position + speedVector;
  Line get path => Line(position, destination);
  Line get trail => Line(lastPosition, position);

  @override
  void update() {
    if (hp <= 0 && isAlive) {
      crash();
    }
  }

  void changeSpeed(Direction direction) {
    speedVector += direction;
    if (speed > topSpeed) {
      changeSpeed(Direction.s);
    }
  }

  bool isFrontOf(Entity other) {
    return position.y < other.position.y;
  }

  bool isBehindOf(Entity other) {
    return position.y > other.position.y;
  }

  bool isLeftOf(Entity other) {
    return position.x < other.position.x;
  }

  bool isRightOf(Entity other) {
    return position.x > other.position.x;
  }

  Car pathIntersects(Car other) {
    var result = linesIntersect(path, other.path);
    if (result) {
      return other;
    }

    return null;
  }

  void move() {
    if (isOffScreen()) {
      updatePosition(destination);
      crash();
      if (this is NPC) {
        updatePosition(Vec(0, track.height + 10));
      }
    } else if (pathIsObstructed()) {
      updatePosition(destination);
      crash();
    } else {
      updatePosition(destination);
    }
  }

  void drift(Direction direction) {
    updatePosition(position + direction);
  }

  void shunt(Car other) {
    other.drift(directionVector);
    other.takeDamage();
  }

  void takeDamage([int amount = 1]) {
    if (this is PlayerCar) {
      if (amount > 1) {
        game.log('Your car takes $amount points of damage!',
            fgColor: ColorScheme.danger);
      } else {
        game.log('Your car takes $amount point of damage!',
            fgColor: ColorScheme.danger);
      }
    }
    hp -= amount;
  }

  bool checkCollision(Entity other) {
    if (other == null) {
      return false;
    }

    if (other is Car) {
      if (speed >= other.speed) {
        if (this is PlayerCar) {
          if (other.wrecked) {
            game.log('You crash through a burning wreck!',
                fgColor: ColorScheme.warning);
            takeDamage();
            changeSpeed(Direction.s);
          } else {
            game.log(
                'You smash into another car, shunting them out of your way!');
          }
        }
        shunt(other);
        if (other is PlayerCar) {
          game.log(
              'Someone smashes into you! You fight to stay in control of your vehicle...',
              fgColor: ColorScheme.warning);
        }

        return true;
      } else {
        if (this is PlayerCar) {
          game.log('You swerve to avoid being hit by another car...');
        }
        drift(other.directionVector);
        return true;
      }
    }

    return false;
  }

  List<Entity> getEntitiesAtSamePosition() {
    var result = <Entity>[];
    for (var entity in game.entities) {
      if (entity != this && entity.position == position) {
        result.add(entity);
      }
    }

    return result;
  }

  void crash() {
    hp = 0;
    wrecked = true;
    speedVector = Vec(0, 0);
  }

  void reset(Vec pos) {
    hp = maxHp;
    position = pos;
    lastPosition = Vec(pos.x, pos.y);
    wrecked = false;
    speedVector = startingSpeedVector;
  }

  Vec nextC([Vec origin]) {
    var p = origin ?? position;
    return p + speedVector;
  }

  bool isOffScreen() {
    return track.outOfBounds(position) && track.outOfBounds(destination);
  }

  bool get positionIsOffScreen => track.outOfBounds(position);
  bool get destinationIsOffScreen => track.outOfBounds(destination);

  bool pathIsObstructed({Vec start, Vec end}) {
    var origin = start ?? position;
    var endPoint = end ?? destination;
    for (var point in bresenham(origin, endPoint)) {
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
            var p = nextC(point) + dVec;
            renderToDisplay(terminal, p, CharCode.plus,
                fgColor: (track.isBlocked(p)
                    ? ColorScheme.danger
                    : ColorScheme.projectionVec));
          }
        } else {
          fgColor = projectionColor;
          charCode = CharCode.middleDot;
        }
        if (pathIsObstructed(start: position, end: point)) {
          fgColor = ColorScheme.danger;
        }

        if (track.withinBounds(point)) {
          renderToDisplay(terminal, point, charCode, fgColor: fgColor);
        }
      }
    }
  }

  void renderDebugInfo(Terminal terminal) {
    // if (this is PlayerCar) {
    //   for (var other in game.npcs) {
    //     pathIntersects(other);
    //   }
    // }

    for (var i = 0; path.elementAt(i) != destination; i++) {
      if (!track.outOfBounds(path.elementAt(i))) {
        renderToDisplay(terminal, path.elementAt(i), CharCode.asterisk,
            fgColor: fgColor);
      }
    }

    if (this is PlayerCar) {
      var line = trail;
      for (var i = 0; line.elementAt(i) != line.end; i++) {
        if (track.withinBounds(line.elementAt(i))) {
          renderToDisplay(terminal, line.elementAt(i), CharCode.asterisk,
              fgColor: fgColor);
        }
      }
    }

    // var line = bresenham(lastPosition, position);
    // for (var point in line) {
    //   renderToDisplay(terminal, point, CharCode.asterisk,
    //       fgColor: Color.orange);
    // }
    // var points = [];
    // points.add(forwardSensor);
    // points.add(nextC(nextC()));
    // points.add(leftSensor);
    // points.add(rightSensor);
    // for (var point in points) {
    //   renderToDisplay(terminal, point, CharCode.plus, fgColor: fgColor);
    // }
  }

  @override
  void render(Terminal terminal) {
    if (isAlive && track.withinBounds(position)) {
      renderToDisplay(terminal, position, charCode,
          fgColor: fgColor, bgColor: bgColor);
    } else if (track.withinBounds(position)) {
      renderToDisplay(terminal, position + Vec(0, -1), CharCode.lightShade,
          fgColor: Color.darkGray, bgColor: Color.black);
      renderToDisplay(terminal, position, CharCode.lowerHalfBlock,
          fgColor: Color.orange, bgColor: Color.red);
    }
  }
}

class PlayerCar extends Car {
  PlayerCar(Game game, Vec position,
      {Color fgColor = Color.purple,
      Color bgColor = Color.black,
      String name = 'Player'})
      : super(game, position, name, fgColor, bgColor) {
    maxHp = 10;
    hp = maxHp;
  }
}

class NPC extends Car {
  NPC(Game game, Vec position,
      {String name = 'NPC',
      Color fgColor = Color.darkYellow,
      Color bgColor = Color.black})
      : super(game, position, name, fgColor, bgColor) {
    maxHp = 5;
    hp = maxHp;
  }

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
    super.update();
    if (isAlive) {
      tryToStayOnTheRoad();
    }
  }

  void tryToStayOnTheRoad() {
    adjustHeading();
  }

  void adjustHeading() {
    var clearLeft = !pathIsObstructed(start: position, end: leftSensor);
    var clearRight = !pathIsObstructed(start: position, end: rightSensor);
    var clearAhead = !pathIsObstructed(start: position, end: forwardSensor);

    if (clearAhead &&
        speed < game.roadMaxSpeed - 1 &&
        track.withinBounds(nextC())) {
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
    } else if (track.outOfBounds(nextC())) {
      slowDown();
    }
  }
}
