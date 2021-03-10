import 'dart:html' as html;
import 'dart:js';
import 'dart:math' as math;

import 'package:malison/malison.dart';
import 'package:malison/malison_web.dart';
import 'package:piecemeal/piecemeal.dart';

import 'package:speedvector7drl/src/game.dart';
import 'package:speedvector7drl/src/maingamescreen.dart';
import 'package:speedvector7drl/src/track.dart';

const int screenWidth = 80;
const int screenHeight = 40;
const int trackWidth = 32;
const int trackHeight = 32;

const Vec trackPanelPosition = Vec(25, 2);

void main() {
  _addFont('8x8', 8);
  _addFont('16x16', 16);

  var fontName = html.window.localStorage['font'];
  _font = _fonts[1];
  for (var thisFont in _fonts) {
    if (thisFont.name == fontName) {
      _font = thisFont;
      break;
    }
  }

  var div = html.querySelector('#game');
  div.append(_font.canvas);

  html.window.onResize.listen((_) {
    _resizeTerminal();
  });

  _ui = UserInterface<String>(_font.terminal);

  _ui.keyPress.bind('up', KeyCode.up);
  _ui.keyPress.bind('down', KeyCode.down);
  _ui.keyPress.bind('right', KeyCode.right);
  _ui.keyPress.bind('left', KeyCode.left);

  _ui.keyPress.bind('sw', KeyCode.numpad1);
  _ui.keyPress.bind('s', KeyCode.numpad2);
  _ui.keyPress.bind('se', KeyCode.numpad3);
  _ui.keyPress.bind('w', KeyCode.numpad4);
  _ui.keyPress.bind('none', KeyCode.numpad5);
  _ui.keyPress.bind('e', KeyCode.numpad6);
  _ui.keyPress.bind('nw', KeyCode.numpad7);
  _ui.keyPress.bind('n', KeyCode.numpad8);
  _ui.keyPress.bind('ne', KeyCode.numpad9);

  _ui.keyPress.bind('confirm', KeyCode.enter);
  _ui.keyPress.bind('period', KeyCode.period);
  _ui.keyPress.bind('comma', KeyCode.comma);
  _ui.keyPress.bind('space', KeyCode.space);
  _ui.keyPress.bind('debug', KeyCode.d);

  _ui.push(MainGameScreen(Game(Track(), trackPanelPosition)));

  _ui.handlingInput = true;
  // _ui.running = true;
} // End of main()

final _fonts = <TerminalFont>[];
UserInterface<String> _ui;

TerminalFont _font;

class TerminalFont {
  final String name;
  final html.CanvasElement canvas;
  RenderableTerminal terminal;
  final int charWidth;
  final int charHeight;

  TerminalFont(this.name, this.canvas, this.terminal,
      {this.charWidth, this.charHeight});
} // End of class TerminalFont

void _addFont(String name, int charWidth, [int charHeight]) {
  charHeight ??= charWidth;

  var canvas = html.CanvasElement();
  canvas.onDoubleClick.listen((_) {
    _fullscreen();
  });

  var terminal = _makeTerminal(canvas, charWidth, charHeight);
  _fonts.add(TerminalFont(name, canvas, terminal,
      charWidth: charWidth, charHeight: charHeight));

  var button = html.ButtonElement();
  button.innerHtml = name;
  button.onClick.listen((_) {
    for (var i = 0; i < _fonts.length; i++) {
      if (_fonts[i].name == name) {
        _font = _fonts[i];
        html.querySelector('#game').append(_font.canvas);
      } else {
        _fonts[i].canvas.remove();
      }
    }

    _resizeTerminal();

    html.window.localStorage['font'] = name;
  });

  // html.querySelector('.button-bar').children.add(button);
} // End of _addFont()

void _fullscreen() {
  var div = html.querySelector('#game');
  var jsElement = JsObject.fromBrowserObject(div);

  var methods = [
    'requestFullscreen',
    'mozRequestFullScreen',
    'webkitRequestFullscreen',
    'msRequestFullscreen'
  ];
  for (var method in methods) {
    if (jsElement.hasProperty(method)) {
      jsElement.callMethod(method);
      return;
    }
  }
} // End of _fullscreen()

RetroTerminal _makeTerminal(
  html.CanvasElement canvas,
  int charWidth,
  int charHeight,
) {
  var width = (html.document.body.clientWidth - 20) ~/ charWidth;
  var height = (html.document.body.clientHeight - 30) ~/ charHeight;

  width = math.max(width, screenWidth);
  height = math.max(height, screenHeight);

  var scale = html.window.devicePixelRatio.toInt();
  var canvasWidth = charWidth * width;
  var canvasHeight = charHeight * height;
  canvas.width = canvasWidth * scale;
  canvas.height = canvasHeight * scale;
  canvas.style.width = '${canvasWidth}px';
  canvas.style.height = '${canvasHeight}px';

  var file = 'assets/fonts/font_$charWidth';
  if (charWidth != charHeight) {
    file += '_$charHeight';
  }

  return RetroTerminal(width, height, '$file.png',
      canvas: canvas, charWidth: charWidth, charHeight: charHeight);
} // End of _makeTerminal()

void _resizeTerminal() {
  var terminal = _makeTerminal(_font.canvas, _font.charWidth, _font.charHeight);

  _font.terminal = terminal;
  _ui.setTerminal(terminal);
  _ui.refresh();
} // End of _resizeTerminal()
