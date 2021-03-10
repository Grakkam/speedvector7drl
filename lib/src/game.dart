import 'dart:math' as math;

import 'package:piecemeal/piecemeal.dart';
import 'package:speedvector7drl/src/entity.dart';
import 'package:speedvector7drl/src/track.dart';

class Game {
  PlayerCar player;
  final _entities = <Entity>[];
  final Track track;
  Vec trackPanelPosition;
  Vec hudPanelPosition;
  int score = 0;
  int highscore = 0;
  int roadMinSpeed = 4;
  int roadMaxSpeed = 6;
  int currentTurn = 0;

  List<Entity> get entities => _entities;
  List<Car> get cars => _entities.whereType<Car>().toList();
  List<NPC> get npcs => _entities.whereType<NPC>().toList();

  Game(this.track, this.trackPanelPosition) {
    player = PlayerCar(this, null);
    addEntity(player);
    addEntity(NPC(this, null));
    addEntity(NPC(this, null));
    addEntity(NPC(this, null));
    addEntity(NPC(this, null));
    addEntity(NPC(this, null));
    startNewGame();
    hudPanelPosition = trackPanelPosition + Vec(track.width + 2, 0);
  }

  void advanceTurnCounter() {
    currentTurn += 1;
  }

  void updateScore(int amount) {
    score += amount;
  }

  void startNewGame() {
    score = 0;
    currentTurn = 0;
    track.initialize();
    player.reset(track.startPosition);
    for (var i = 0; i < npcs.length; i++) {
      npcs[i].reset(track.startPosition + Vec(-6, -5) + Vec(-i, -i));
    }
    npcs[0].reset(track.startPosition + Vec(-6, -5));
    npcs[1].reset(track.startPosition + Vec(-8, -3));
  }

  void end() {
    highscore = math.max(highscore, score);
    startNewGame();
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
