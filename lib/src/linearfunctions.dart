import 'dart:math' as math;

import 'package:piecemeal/piecemeal.dart';

bool onLine(Line l1, Vec p) {
  // Check whether p is on the line or not
  if ((p.x <= math.max(l1.start.x, l1.end.x)) &&
      (p.x >= math.min(l1.start.x, l1.end.x)) &&
      (p.y <= math.max(l1.start.y, l1.end.y)) &&
      (p.y >= math.min(l1.start.y, l1.end.y))) {
    return true;
  }

  return false;
}

int checkDirection(Vec a, Vec b, Vec c) {
  // -1 is anti-clockwise
  // 0 is collinear
  // 1 is clockwise
  var value = (b.y - a.y) * (c.x - b.x) - (b.x - a.x) * (c.y - b.y);
  if (value < 0) {
    value = -1;
  } else if (value > 0) {
    value = 1;
  }

  return value;
}

bool linesIntersect(Line l1, Line l2) {
  var dir1 = checkDirection(l1.start, l1.end, l2.start);
  var dir2 = checkDirection(l1.start, l1.end, l2.end);
  var dir3 = checkDirection(l2.start, l2.end, l1.start);
  var dir4 = checkDirection(l2.start, l2.end, l1.end);

  if (dir1 != dir2 && dir3 != dir4) {
    return true;
  }
  if (dir1 == 0 && onLine(l1, l2.start)) {
    return true;
  }
  if (dir2 == 0 && onLine(l1, l2.end)) {
    return true;
  }
  if (dir3 == 0 && onLine(l2, l1.start)) {
    return true;
  }
  if (dir4 == 0 && onLine(l2, l1.end)) {
    return true;
  }

  return false;
}
