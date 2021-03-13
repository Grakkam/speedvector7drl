import 'dart:math' as math;

import 'package:malison/malison.dart';
import 'package:piecemeal/piecemeal.dart';
import 'package:speedvector7drl/src/colorscheme.dart';
import 'package:speedvector7drl/src/road.dart';

class Track {
  final int _width;
  final int _height;
  List<String> _road;
  List<Vec> _startingPositions = [];

  List<Vec> get startingPositions => _startingPositions;

  int get width => _width;
  int get height => _height;

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
    _startingPositions = [
      Vec(14, height - 8),
      Vec(16, height - 8),
      Vec(12, height - 6),
      Vec(18, height - 6),
      Vec(10, height - 4),
      Vec(20, height - 4),
    ];

    var roadSection = Road.wideStraight.first;

    _road = List.filled(height, roadSection, growable: true);

    initializeNewRoad();
  }

  void rollDown([int amount = 1]) {
    for (var i = 0; i < amount; i++) {
      // update();
      _road.insert(0, generateRoadSection());
      _road.removeLast();
    }
  }

  void update([int numberOfRolldowns = 1]) {}

  String generateRoadSection() {
    rollRoad();
    return _currentSection.last;
  }

  bool outOfBounds(Vec p) {
    return p.x < 0 || p.x > width - 1 || p.y < 0 || p.y > height - 1;
  }

  bool withinBounds(Vec p) {
    return p.x >= 0 && p.x < width && p.y >= 0 && p.y < height;
  }

  bool isBlocked(Vec p) {
    if (outOfBounds(p)) {
      return false;
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

  void renderDebugInfo(Terminal terminal) {}

  final List<String> _currentSection = List.empty(growable: true);
  final List<String> _nextSection = List.empty(growable: true);

  RoadStyle _roadStyle = RoadStyle.wide;

  bool get roadIsWide => _roadStyle == RoadStyle.wide;
  bool get roadIsNarrowCenter => _roadStyle == RoadStyle.narrowCenter;
  bool get roadIsNarrowRight => _roadStyle == RoadStyle.narrowRight;
  bool get roadIsNarrowLeft => _roadStyle == RoadStyle.narrowLeft;

  void setRoadNarrowCenter() {
    _roadStyle = RoadStyle.narrowCenter;
  }

  void setRoadNarrowRight() {
    _roadStyle = RoadStyle.narrowRight;
  }

  void setRoadNarrowLeft() {
    _roadStyle = RoadStyle.narrowLeft;
  }

  void setRoadWide() {
    _roadStyle = RoadStyle.wide;
  }

  List<String> generateRoad() {
    var roadSections = [];

    if (roadIsWide && randomBool) {
      setRoadNarrowCenter();
      return Road.wideToNarrowCenter;
    } else if (roadIsNarrowCenter && randomBool) {
      if (randomBool) {
        setRoadNarrowRight();
        return Road.narrowCenterToNarrowRight;
      } else if (randomBool) {
        setRoadNarrowLeft();
        return Road.narrowCenterToNarrowLeft;
      } else {
        setRoadWide();
        return Road.narrowCenterToWide;
      }
    } else if (roadIsNarrowRight && randomBool) {
      if (randomBool) {
        setRoadNarrowCenter();
        return Road.narrowRightToNarrowCenter;
      } else if (randomBool) {
        setRoadNarrowLeft();
        return Road.narrowRightToNarrowLeft;
      }
    } else if (roadIsNarrowLeft && randomBool) {
      if (randomBool) {
        setRoadNarrowCenter();
        return Road.narrowLeftToNarrowCenter;
      } else if (randomBool) {
        setRoadNarrowRight();
        return Road.narrowLeftToNarrowRight;
      }
    }

    switch (_roadStyle) {
      case RoadStyle.wide:
        roadSections.addAll(Road.wideSections);
        break;
      case RoadStyle.narrowCenter:
        roadSections.addAll(Road.narrowCenterSections);
        break;
      case RoadStyle.narrowRight:
        roadSections.addAll(Road.narrowRightSections);
        break;
      case RoadStyle.narrowLeft:
        roadSections.addAll(Road.narrowLeftSections);
        break;
      default:
        roadSections.addAll(Road.wideSections);
    }

    var randomNumber = randomInt(0, roadSections.length);
    return roadSections[randomNumber];
  }

  void initializeNewRoad() {
    _currentSection.clear();
    _nextSection.clear();
    _roadStyle = RoadStyle.wide;
    _currentSection.addAll(Road.wideStraight);
    _nextSection.addAll(generateRoad());
  }

  void rollRoad([int amount = 1]) {
    if (_nextSection.isEmpty) {
      _nextSection.addAll(generateRoad());
    }
    _currentSection.insert(0, _nextSection.removeLast());
    _currentSection.removeLast();
  }
}
