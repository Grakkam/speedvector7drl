import 'dart:math' as math;

import 'package:malison/malison.dart';
import 'package:malison/malison_web.dart';
import 'package:speedvector7drl/src/game.dart';
import 'package:speedvector7drl/src/messagelog.dart';
import 'package:speedvector7drl/src/renderfunctions.dart';

class InstructionsScreen extends Screen<String> {
  final Game _game;

  int logLength;
  int cursor = 7;
  int adjust = 0;
  UIBox logWindow;
  int logX;
  int logY;
  int logWidth;
  int logHeight;

  MessageLog instructions;

  InstructionsScreen(this._game) {
    instructions = MessageLog();
    initialize();
    logLength = instructions.messages.length;
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
      title: 'How to Play',
      color: Color.darkAqua,
      titleColor: Color.darkYellow,
    );
  }

  Game get game => _game;

  void add(String text, {Color fgColor = Color.white, bool stack = true}) {
    instructions.addMessage(text: text, fg: fgColor, stack: stack);
  }

  @override
  bool keyDown(int keyCode, {bool shift, bool alt}) {
    if (keyCode == KeyCode.escape ||
        keyCode == KeyCode.enter ||
        keyCode == KeyCode.numpadEnter) {
      ui.pop();
    }

    if (keyCode == KeyCode.up || keyCode == KeyCode.numpad8) {
      adjust = -1;
    } else if (keyCode == KeyCode.down || keyCode == KeyCode.numpad2) {
      adjust = 1;
    }
    if (shift) {
      adjust *= 10;
    }

    if (adjust < 0 && cursor == 0) {
      cursor = 7;
    } else if (adjust > 0 && cursor == logLength - 1) {
      // cursor = 0;
    } else {
      cursor = math.max(0, math.min(cursor + adjust, logLength - 1));
    }

    dirty();

    return false;
  }

  @override
  void render(Terminal terminal) {
    logWindow.render(terminal);

    var messages = instructions.messages.getRange(0, cursor + 1);
    instructions.renderMessages(terminal, logX + 2, logY + 2, logWidth - 4,
        logHeight - 4, messages.toList());

    renderButton(terminal, 4, logY + logHeight + 2, '<< Back', selected: true);
  }

  void initialize() {
    add('The basic idea of SPEED VECTOR is simple:');
    add('You drive your car along a never-ending, procedurally generated stretch of road.',
        fgColor: Color.gray);
    add('You must stay on the road, and try to not get too banged up by the other motorists in the process.',
        fgColor: Color.gray);
    add(' ');
    add('Your car τ has a "speed vector", basically an x/y coordinate, that gets added to your car\'s position each turn, giving your new position.');
    add('You can control your car by changing this vector by picking one of the (usually nine) possible choices using your cursor: +');
    add(' ');
    add('Whatever point you choose, that is where you will (generally) end up after your move.',
        fgColor: Color.gray);
    add('Exceptions exist. For instance, you can be knocked slightly off course by bumping into other cars.',
        fgColor: Color.gray);
    add(' ');
    add('                       ···', fgColor: Color.darkGray);
    add('                       ·+·', fgColor: Color.darkGray);
    add('                       ···', fgColor: Color.darkGray);
    add(' ');
    add('                        τ', fgColor: Color.purple);
    add(' ');
    add('Pick one of the three top directions and you speed up. The middle three means you stay at your current speed. The bottom three lowers your speed, allowing you to take tighter turns.',
        fgColor: Color.gray);
    add(' ');
    add('But watch out! If you go too slow, or too fast, you will risk moving off screen and be eliminated!',
        fgColor: Color.red);
    add(' ');
    add('You can move the cursor using the arrow keys. Confirm your choice with a press on the [enter] key and off you go!');
    add(' ');
    add('Choices that light up in red are moves that will result in a crash, so watch your speed!',
        fgColor: Color.red);
    add(' ');
    add('When you\'re ready for even more speed, you can use the numpad keys [1-9] to instantly select a direction and move, without having to manually confirm your choice.');
    add(' ');
    add('After all cars have moved, the road "rolls" down a number of steps. For every piece of road that disappears from the bottom of the screen, a new piece of fresh road appears at the top.');
    add(' ');
    add('That\'s basically all you need to know to get started. Some more instructions are available on the main game screen when you actually play the game.',
        fgColor: Color.gray);
    add(' ');
    add('Now go and burn some rubber!!!', fgColor: Color.orange);
  }
}
