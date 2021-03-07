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
  int _minRoadEdgeWidth;
  int _minRoadWidth;
  int _maxRoadWidth;
  Vec _startPosition;

  Vec get startPosition => _startPosition;

  bool _bendingLeft = false;
  bool _bendingRight = false;
  bool _widening = false;
  bool _narrowing = false;

  bool get roadBendingLeft => _bendingLeft;
  bool get roadBendingRight => _bendingRight;
  bool get roadWidening => _widening;
  bool get roadNarrowing => _narrowing;

  void toggleBendingLeft() {
    _bendingLeft = !_bendingLeft;
  }

  void toggleBendingRight() {
    _bendingRight = !_bendingRight;
  }

  void toggleWidening() {
    _widening = !_widening;
  }

  void toggleNarrowing() {
    _narrowing = !_narrowing;
  }

  int get width => _width;
  int get height => _height;

  int get leftEdge => _roadOffset;
  int get rightEdge => leftEdge + _roadWidth - 1;
  bool get roomLeft => leftEdge > _minRoadEdgeWidth;
  bool get roomRight => rightEdge < width - _minRoadEdgeWidth - 1;
  bool get roadAtMinWidth => _roadWidth <= _minRoadWidth;
  bool get roadAtMaxWidth => _roadWidth >= _maxRoadWidth;
  bool get roadWide => _roadWidth > _minRoadWidth;
  int get roomOnLeft => leftEdge - _minRoadEdgeWidth;
  int get roomOnRight => width - rightEdge - _minRoadEdgeWidth - 1;

  final math.Random _random = math.Random();

  bool get randomBool => _random.nextBool();
  int randomInt(int min, int max) {
    return _random.nextInt(max - min) + min;
  }

  double get randomDouble => _random.nextDouble();

  Track(this._width, this._height) {
    initialize();
  }

  void initialize() {
    _minRoadEdgeWidth = 2;
    _minRoadWidth = 12;
    _maxRoadWidth = width - _minRoadEdgeWidth * 2;
    _roadWidth = _maxRoadWidth;
    _roadOffset = _minRoadEdgeWidth;
    _startPosition = Vec(rightEdge - 2, height - 5);

    var roadSection = generateRoadSection();

    _road = List.filled(height, roadSection, growable: true);
  }

  void rollDown() {
    _road.insert(0, generateRoadSection());
    _road.removeLast();
  }

  void narrowRoad() {
    if (_roadWidth > _minRoadWidth) {
      _roadWidth -= 2;
      if (roomRight && randomBool) {
        rollRoadRight();
      }
    }
  }

  void onNarrowing() {
    narrowRoad();
  }

  void widenRoad() {
    if (_roadWidth < _maxRoadWidth) {
      _roadWidth += 2;
      if (roomLeft && randomBool) {
        rollRoadLeft();
      }
    }
  }

  void onWidening() {
    widenRoad();
    if (!roomRight) {
      rollRoadLeft();
    }
  }

  void rollRoadLeft() {
    if (roomLeft) {
      _roadOffset -= 1;
    }
  }

  void onBendingLeft() {
    rollRoadLeft();
  }

  void rollRoadRight() {
    if (roomRight) {
      _roadOffset += 1;
    }
  }

  void onBendingRight() {
    rollRoadRight();
  }

  int _counter = 0;

  bool get countdownDone => _counter <= 0;

  void setCountdown([int nrOfTurns]) {
    _counter = nrOfTurns ?? randomInt(4, 9);
  }

  void countdown() {
    if (_counter > 0) {
      _counter -= 1;
    }
  }

  void resetRoadChanges() {
    _bendingLeft = false;
    _bendingRight = false;
    _narrowing = false;
    _widening = false;
  }

  void update() {
    countdown();
    if (countdownDone) {
      resetRoadChanges();

      if (randomBool) {
        setCountdown();

        if (roadWide && randomBool) {
          toggleNarrowing();
        } else if (roomOnLeft > roomOnRight || (randomBool && roomLeft)) {
          toggleBendingLeft();
        } else if (roomOnRight > roomOnLeft || (randomBool && roomRight)) {
          toggleBendingRight();
        } else if (randomBool && !roadAtMinWidth) {
          toggleNarrowing();
        }
      }
    }

    if (roadWidening) {
      onWidening();
      if (countdownDone) {
        toggleWidening();
      }
    } else if (roadNarrowing) {
      onNarrowing();
      if (countdownDone) {
        toggleNarrowing();
      }
    } else if (roadBendingLeft) {
      onBendingLeft();
      if (countdownDone) {
        toggleBendingLeft();
      }
    } else if (roadBendingRight) {
      onBendingRight();
      if (countdownDone) {
        toggleBendingRight();
      }
    }
  }

  String generateRoadSection() {
    var roadSection = '';

    var char;
    for (var x = 0; x < width; x++) {
      if (x < leftEdge || x > rightEdge) {
        char = '#';
      } else {
        char = '.';
      }

      roadSection += char;
    }

    return roadSection;
  }

  bool outOfBounds(Vec p) {
    return p.x < 0 || p.x > width - 1 || p.y < 0 || p.y > height - 1;
  }

  bool isBlocked(Vec p) {
    if (outOfBounds(p)) {
      return true;
    }
    return (_road[p.y][p.x] == '#');
  }

  String tileAt(Vec p) {
    return _road[p.y][p.x];
  }

  void render(Terminal terminal, int xPos, int yPos,
      {bool showGrid = false, bool debugMode = false}) {
    if (debugMode) {
      renderDebugInfo(terminal);
    }

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

  void renderDebugInfo(Terminal terminal) {
    terminal.writeAt(2, 2, '_bendingLeft: $_bendingLeft');
    terminal.writeAt(2, 3, '_bendingRight: $_bendingRight');
    terminal.writeAt(2, 4, '_widening: $_widening');
    terminal.writeAt(2, 5, '_narrowing: $_narrowing');
    terminal.writeAt(2, 6, '_counter: $_counter');
    // terminal.writeAt(2, 7, 'currentWidth: $currentWidth');
    terminal.writeAt(2, 8, '_roadOffset: $_roadOffset');
    terminal.writeAt(2, 9, '_roadWidth: $_roadWidth');
    terminal.writeAt(2, 10, '_minRoadWidth: $_minRoadWidth');
    terminal.writeAt(2, 11, '_maxRoadWidth: $_maxRoadWidth');
    // terminal.writeAt(2, 12, 'atMaxWidth: $atMaxWidth');
    terminal.writeAt(2, 13, 'leftEdge: $leftEdge');
    terminal.writeAt(2, 14, 'rightEdge: $rightEdge');
    terminal.writeAt(2, 15, 'roomOnLeft: $roomOnLeft');
    terminal.writeAt(2, 16, 'roomOnRight: $roomOnRight');
  }
}
