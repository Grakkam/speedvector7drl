import 'package:speedvector7drl/src/game.dart';
import 'package:speedvector7drl/src/infoscreen.dart';

class MessageLogScreen extends InfoScreen {
  MessageLogScreen(Game game, String title) : super(game, title);

  @override
  void initialize() {
    content.messages.addAll(game.messageLog.messages);
  }
}
