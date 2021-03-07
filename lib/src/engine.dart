import 'dart:math' as math;

import 'package:malison/malison_web.dart';
import 'package:piecemeal/piecemeal.dart';
import 'package:speedvector7drl/src/car.dart';
import 'package:speedvector7drl/src/colorscheme.dart';
import 'package:speedvector7drl/src/track.dart';

class Engine {
  final UserInterface ui;

  final Player _player;
  final Track _track;
  final Vec _trackScreenPosition;
  final roadHighSpeed = 6;
  final roadLowSpeed = 4;
  int _score = 0;
  int _highscore = 0;
  int _currentTurn = 0;
  final List<NPC> _opponents = <NPC>[];

  Engine(this.ui, this._track, this._trackScreenPosition, this._player) {
    player.bind(this);
  }

  Player get player => _player;
  Track get track => _track;
  Vec get trackScreenPosition => _trackScreenPosition;
  int get score => _score;
  int get highscore => _highscore;
  int get currentTurn => _currentTurn;
  List<NPC> get npcs => _opponents;

  void addOpponent() {
    var npc = NPC();
    npc.bind(this);
    _opponents.add(npc);
  }

  void startNewGame() {
    _score = 0;
    _currentTurn = 0;
    player.reset();
    player.updateColor(ColorScheme.player);
    track.initialize();
    player.park(track.startPosition);
    if (npcs.isEmpty) {
      addOpponent();
      npcs[0].park(Vec(15, 7));
    }
  }

  void endOfTurn() {
    if (player.isAlive) {
      updateScore();
      _currentTurn += 1;
    } else {
      _highscore = math.max(_highscore, score);
      startNewGame();
    }
  }

  void updateScore() {
    _score += player.absoluteSpeed + currentTurn;
  }

  void update() {
    var speed =
        math.min(math.max(player.speed.y.abs(), roadLowSpeed), roadHighSpeed);
    if (npcs.isNotEmpty) {
      for (var npc in npcs) {
        if (npc.isAlive) {
          npc.move();
          npc.update(speed);
        } else {
          if (track.outOfBounds(npc.pos)) {
            npc.reset();
            npc.park(Vec(track.width ~/ 2, 0));
          }
        }
      }
    }
    player.move();
    for (var i = 0; i < speed; i++) {
      track.update();
      track.rollDown();
      if (npcs.isNotEmpty) {
        for (var npc in npcs) {
          npc.rollDown();
        }
      }
      player.rollDown();
    }

    endOfTurn();
  }
}
