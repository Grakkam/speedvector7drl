import 'package:piecemeal/piecemeal.dart';

List<Vec> bresenham(Vec p0, Vec p1) {
  var points = <Vec>[];

  var x0 = p0.x;
  var y0 = p0.y;
  var x1 = p1.x;
  var y1 = p1.y;
  var dx = x1 - x0;
  var dy = y1 - y0;

  var isSteep = dy.abs() > dx.abs();

  if (isSteep) {
    var foo = x0;
    x0 = y0;
    y0 = foo;
    foo = x1;
    x1 = y1;
    y1 = foo;
  }

  var swapped = false;
  if (x0 > x1) {
    var foo = x0;
    x0 = x1;
    x1 = foo;
    foo = y0;
    y0 = y1;
    y1 = foo;
    swapped = true;
  }

  dx = x1 - x0;
  dy = y1 - y0;

  var error = dx ~/ 2;
  var ystep = (y0 < y1) ? 1 : -1;

  var y = y0;

  for (var x = x0; x < x1 + 1; x++) {
    var coord = (isSteep) ? Vec(y, x) : Vec(x, y);
    points.add(coord);
    error -= dy.abs();
    if (error < 0) {
      y += ystep;
      error += dx;
    }
  }

  if (swapped) {
    return points.reversed.toList();
  }

  return points;
}

List<Vec> plotLine(Vec p0, Vec p1) {
  var x0 = p0.x;
  var y0 = p0.y;
  var x1 = p1.x;
  var y1 = p1.y;

  if ((y1 - y0).abs() < (x1 - x0).abs()) {
    if (x0 > x1) {
      return plotLineLow(x1, y1, x0, y0);
    } else {
      return plotLineLow(x0, y0, x1, y1);
    }
  } else {
    if (y0 > y1) {
      return plotLineHigh(x1, y1, x0, y0);
    } else {
      return plotLineHigh(x0, y0, x1, y1);
    }
  }
}

List<Vec> plotLineLow(x0, y0, x1, y1) {
  var line = <Vec>[];
  var dx = x1 - x0;
  var dy = y1 - y0;
  var yi = 1;

  if (dy < 0) {
    y1 = -1;
    dy = -dy;
  }

  var d = (2 * dy) - dx;
  var y = y0;
  for (var x = x0; x <= x1; x++) {
    line.add(Vec(x, y));
    if (d > 0) {
      y += yi;
      d += (2 * (dy - dx));
    } else {
      d += 2 * dy;
    }
  }

  return line;
}

List<Vec> plotLineHigh(x0, y0, x1, y1) {
  var line = <Vec>[];
  var dx = x1 - x0;
  var dy = y1 - y0;
  var xi = 1;
  if (dx < 0) {
    xi = -1;
    dx = -dx;
  }
  var d = (2 * dx) - dy;
  var x = x0;

  for (var y = y0; y <= y1; y++) {
    line.add(Vec(x, y));
    if (d > 0) {
      x += xi;
      d += (2 * (dx - dy));
    } else {
      d += 2 * dx;
    }
  }

  return line;
}
