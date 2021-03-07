import 'package:malison/malison_web.dart';
import 'package:piecemeal/piecemeal.dart';
import 'package:speedvector7drl/src/car.dart';
import 'package:speedvector7drl/src/track.dart';

class Engine {
  final UserInterface ui;

  final Car _car;
  final Track _track;
  final Vec _trackPosition;
  final roadHighSpeed = 6;
  final roadLowSpeed = 4;

  Engine(this.ui, this._track, this._trackPosition, this._car) {
    car.bind(this);
  }

  Car get car => _car;
  Track get track => _track;
  Vec get trackPosition => _trackPosition;
}
