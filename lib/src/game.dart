import 'dart:math' as math;

import 'package:malison/malison.dart';
import 'package:piecemeal/piecemeal.dart';
import 'package:speedvector7drl/src/colorscheme.dart';
import 'package:speedvector7drl/src/entity.dart';
import 'package:speedvector7drl/src/messagelog.dart';
import 'package:speedvector7drl/src/track.dart';

class Game {
  final String version = '0.7.0';

  MessageLog _messageLog;
  PlayerCar player;
  final _entities = <Entity>[];
  final Track track;
  Vec trackPanelPosition;
  Vec hudPanelPosition;
  Vec instructionsPanelPosition;
  Vec logPanelPosition;
  Vec logPanelSize;
  int score = 0;
  int highscore = 0;
  int roadMinSpeed = 4;
  int roadMaxSpeed = 6;
  int currentTurn = 0;
  bool turnOver = false;
  bool gameIsRunning = false;

  MessageLog get messageLog => _messageLog;

  List<Entity> get entities => _entities;
  List<Car> get cars => _entities.whereType<Car>().toList();
  List<NPC> get npcs => _entities.whereType<NPC>().toList();

  Game(this.track, this.trackPanelPosition) {
    _messageLog = MessageLog();
    player = PlayerCar(this, null);
    addEntity(player);
    var npcColors = [
      Color.aqua,
      Color.yellow,
      Color.red,
      Color.orange,
      Color.green
    ];
    for (var i = 0; i < 5; i++) {
      addEntity(NPC(this, null, name: 'NPC$i', fgColor: npcColors[i]));
    }
    startNewGame();
    hudPanelPosition = trackPanelPosition + Vec(track.width + 2, 0);
    instructionsPanelPosition = Vec(1, 2);
    logPanelPosition = Vec(5, trackPanelPosition.y + track.height + 1);
    logPanelSize = Vec(60, 5);
  }

  void log(String text, {Color fgColor = Color.gray, bool stack = true}) {
    messageLog.addMessage(text: text, fg: fgColor, stack: stack);
  }

  void endTurn() {
    turnOver = true;

    if (gameIsRunning == false) {
      startNewGame();
    }
  }

  void startNewTurn() {
    advanceTurnCounter();
    turnOver = false;
  }

  void advanceTurnCounter() {
    currentTurn += 1;
  }

  void updateScore(int amount) {
    score += amount;
  }

  void end() {
    if (score > highscore) {
      log('...but you also beat the high score, awesome!',
          fgColor: ColorScheme.success);
    }
    highscore = math.max(highscore, score);
    endTurn();
    log('<<< Press [ENTER] to race again! >>>', fgColor: ColorScheme.info);
    gameIsRunning = false;
  }

  void startNewGame() {
    messageLog.messages.clear();
    log('Start your engines!', fgColor: Color.orange);
    score = 0;
    currentTurn = 0;

    track.initialize();

    for (var car in cars) {
      var pos = track.startingPositions
          .removeAt(track.randomInt(0, track.startingPositions.length));
      car.reset(pos);
    }

    turnOver = false;
    gameIsRunning = true;
  }

  void addEntity(Entity entity) {
    _entities.add(entity);
  }

  void removeEntity(Entity entity) {
    _entities.remove(entity);
  }

  Entity entityAtPosition(Vec pos) {
    for (var entity in entities) {
      if (entity.position == pos) {
        return entity;
      }
    }

    return null;
  }
}
