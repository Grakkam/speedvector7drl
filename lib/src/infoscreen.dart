import 'dart:html' as html;
import 'dart:math' as math;

import 'package:malison/malison.dart';
import 'package:piecemeal/piecemeal.dart';
import 'package:speedvector7drl/src/game.dart';
import 'package:speedvector7drl/src/messagelog.dart';
import 'package:speedvector7drl/src/renderfunctions.dart';
import 'package:speedvector7drl/src/ui.dart';

class InfoScreen extends ScreenWithMouse<String> {
  final Game _game;

  Game get game => _game;

  int choice = 2;
  List<String> options = ['<< Back', '▲ Up', '▼ Down'];
  List<Button> buttons = [];

  int logLength;
  int cursor = 7;
  int adjust = 0;
  UIBox logWindow;
  int logX;
  int logY;
  int logWidth;
  int logHeight;

  String title;

  MessageLog content;

  InfoScreen(this._game, this.title) {
    content = MessageLog();
    initialize();
    logLength = content.messages.length;
    logX = 4;
    logY = 4;
    logWidth = 60 - logX * 2;
    logHeight = 30 - logY * 2;
    logWindow = UIBox(
      game,
      logX,
      logY,
      logWidth,
      logHeight,
      title: title,
      color: Color.darkAqua,
      titleColor: Color.darkYellow,
    );

    var buttonX = logX + 1;
    var buttonY = logY + logHeight + 2;

    buttons.add(
        Button(Vec(buttonX, buttonY), options[0], Color.darkAqua, Color.aqua));
    buttonX += logWidth - 2 * 8 - 1;
    buttons.add(
        Button(Vec(buttonX, buttonY), options[1], Color.darkAqua, Color.aqua));
    buttonX = logX + logWidth - 8;
    buttons.add(
        Button(Vec(buttonX, buttonY), options[2], Color.darkAqua, Color.aqua));
  }

  void add(String text, {Color fgColor = Color.white, bool stack = true}) {
    content.addMessage(text: text, fg: fgColor, stack: stack);
  }

  @override
  bool keyDown(int keyCode, {bool shift, bool alt}) {
    if (keyCode == KeyCode.escape || keyCode == KeyCode.numpad0) {
      ui.pop();
      dirty();
      return true;
    }

    if (keyCode == KeyCode.up ||
        keyCode == KeyCode.numpad8 ||
        keyCode == KeyCode.down ||
        keyCode == KeyCode.numpad2) {
      if (keyCode == KeyCode.up || keyCode == KeyCode.numpad8) {
        choice = 1;
        adjust = -1;
        dirty();
      } else if (keyCode == KeyCode.down || keyCode == KeyCode.numpad2) {
        choice = 2;
        adjust = 1;
        dirty();
      }

      clampAdjust();
    } else if (keyCode == KeyCode.left || keyCode == KeyCode.numpad4) {
      updateChoice(-1);
      dirty();
    } else if (keyCode == KeyCode.right || keyCode == KeyCode.numpad6) {
      updateChoice(1);
      dirty();
    } else if (keyCode == KeyCode.enter ||
        keyCode == KeyCode.numpadEnter ||
        keyCode == KeyCode.numpad5) {
      confirmChoice();
      dirty();
    } else {
      return false;
    }

    dirty();

    return false;
  }

  void clampAdjust() {
    if (adjust < 0 && cursor == 0) {
      cursor = 7;
    } else {
      cursor = math.max(0, math.min(cursor + adjust, logLength - 1));
    }
  }

  @override
  bool mouseUp(html.MouseEvent mouseEvent) {
    for (var i = 0; i < buttons.length; i++) {
      if (buttons[i].hoveredOver(mousePosition16)) {
        choice = i;
        confirmChoice();
      }
    }
    return true;
  }

  @override
  bool mouseMove(html.MouseEvent mouseEvent) {
    for (var i = 0; i < buttons.length; i++) {
      if (buttons[i].hoveredOver(mousePosition16)) {
        choice = i;
      }
    }
    dirty();
    return true;
  }

  void updateChoice(int amount) {
    choice += amount;
    if (choice < 0) {
      choice = 0;
    }
    if (choice > options.length - 1) {
      choice = options.length - 1;
    }
  }

  void confirmChoice() {
    switch (choice) {
      case 0:
        ui.pop();
        dirty();
        break;
      case 1:
        adjust = -1;
        clampAdjust();
        dirty();
        break;
      case 2:
        adjust = 1;
        clampAdjust();
        dirty();
        break;
      default:
    }
  }

  @override
  void render(Terminal terminal) {
    logWindow.render(terminal);

    var messages = content.messages
        .getRange(0, math.min(cursor + 1, content.messages.length));
    content.renderMessages(terminal, logX + 2, logY + 2, logWidth - 4,
        logHeight - 4, messages.toList());

    for (var i = 0; i < options.length; i++) {
      buttons[i].render(terminal, (choice == i));
    }
  }

  void initialize() => false;
}
