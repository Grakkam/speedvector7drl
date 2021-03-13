import 'package:malison/malison.dart';
import 'package:piecemeal/piecemeal.dart';
import 'package:speedvector7drl/src/game.dart';

class UIBox {
  final Game _game;
  final int _x;
  final int _y;
  final int _width;
  final int _height;
  int _left;
  int _right;
  int _top;
  int _bottom;
  Color _color;
  Color _backColor;
  Color _titleColor;
  Color _titleBackColor;
  Color _fillColor;
  String _borderChars;
  String _title;
  bool _clear;

  Game get game => _game;

  UIBox(this._game, this._x, this._y, this._width, this._height,
      {String title,
      Color color = Color.white,
      Color backColor = Color.black,
      Color fillColor = Color.black,
      Color titleColor = Color.white,
      Color titleBackColor = Color.black,
      bool clear = false,
      bool single = false}) {
    _color = color;
    _backColor = backColor;
    _fillColor = fillColor;
    _titleColor = titleColor;
    _titleBackColor = titleBackColor;
    _title = title ?? '';
    _clear = clear;
    _left = _x;
    _right = _x + _width;
    _top = _y;
    _bottom = _y + _height;
    if (single) {
      _borderChars = '┌┐└┘│─┤├';
    } else {
      _borderChars = '╔╗╚╝║═╡╞';
    }
  }

  void render(Terminal terminal) {
    if (!_clear) {
      terminal.fill(_left + 1, _top + 1, _width - 1, _height - 1, _fillColor);
    }
    for (var x = 0; x < _width; x++) {
      var backColor = _backColor;
      var pos = Vec(_left + x, _top);
      terminal.drawChar(
          pos.x, pos.y, _borderChars.codeUnitAt(5), _color, backColor);

      backColor = _backColor;
      pos = Vec(_left + x, _bottom);

      terminal.drawChar(
          pos.x, pos.y, _borderChars.codeUnitAt(5), _color, backColor);
    }
    for (var y = 0; y < _height; y++) {
      var backColor = _backColor;
      var pos = Vec(_left, _top + y);
      terminal.drawChar(
          _left, _top + y, _borderChars.codeUnitAt(4), _color, backColor);

      backColor = _backColor;
      pos = Vec(_right, _top + y);

      terminal.drawChar(
          _right, _top + y, _borderChars.codeUnitAt(4), _color, backColor);
    }

    var backColor = _backColor;
    var pos = Vec(_left, _top);

    terminal.drawChar(
        pos.x, pos.y, _borderChars.codeUnitAt(0), _color, backColor);

    backColor = _backColor;
    pos = Vec(_right, _top);
    terminal.drawChar(
        _right, _top, _borderChars.codeUnitAt(1), _color, backColor);

    backColor = _backColor;
    pos = Vec(_left, _bottom);
    terminal.drawChar(
        _left, _bottom, _borderChars.codeUnitAt(2), _color, backColor);

    backColor = _backColor;
    pos = Vec(_right, _bottom);
    terminal.drawChar(
        _right, _bottom, _borderChars.codeUnitAt(3), _color, backColor);

    if (_title.isNotEmpty) {
      var title = ' ' + _title + ' ';
      terminal.drawChar(
          _left + 2, _top, _borderChars.codeUnitAt(6), _color, _backColor);
      terminal.writeAt(_left + 3, _top, title, _titleColor, _titleBackColor);
      terminal.drawChar(_left + title.length + 3, _top,
          _borderChars.codeUnitAt(7), _color, _backColor);
    }
  }
}

void renderButton(Terminal terminal, int x, int y, String text,
    {bool selected = false}) {
  var fgColor;
  var bgColor;
  if (selected) {
    fgColor = Color.black;
    bgColor = Color.aqua;
  } else {
    fgColor = Color.darkGray;
    bgColor = Color.darkAqua;
  }

  terminal.writeAt(x, y, ' $text ', fgColor, bgColor);
}
