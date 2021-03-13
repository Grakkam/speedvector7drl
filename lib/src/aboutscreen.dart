import 'package:speedvector7drl/src/game.dart';
import 'package:speedvector7drl/src/infoscreen.dart';

class AboutScreen extends InfoScreen {
  AboutScreen(Game game, String title) : super(game, title);

  @override
  void initialize() {
    add('Speed Vector - 7DRL 2021 Edition');
  }
}
