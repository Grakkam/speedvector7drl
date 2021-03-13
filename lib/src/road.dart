enum RoadStyle { wide, narrowCenter, narrowRight, narrowLeft }

class Road {
  static const wideToNarrowCenter = [
    '##########............##########',
    '##########............##########',
    '##########.............#########',
    '#########..............#########',
    '#########...............########',
    '########.................#######',
    '#######..................#######',
    '######....................######',
    '#####......................#####',
    '####........................####',
    '####........................####',
    '###..........................###',
    '###..........................###',
    '###..........................###',
    '###..........................###',
    '###..........................###',
    '###..........................###',
    '###..........................###',
  ];
  static const narrowCenterToWide = [
    '###..........................###',
    '###..........................###',
    '###..........................###',
    '###..........................###',
    '###..........................###',
    '###.........................####',
    '###.........................####',
    '###........................#####',
    '####.......................#####',
    '####.......................#####',
    '#####.....................######',
    '######...................#######',
    '######...................#######',
    '#######.................########',
    '########................########',
    '#########..............#########',
    '#########..............#########',
    '##########............##########',
    '##########............##########',
  ];
  static const narrowLeftToNarrowCenter = [
    '##########............##########',
    '##########............##########',
    '##########............##########',
    '#########............###########',
    '#########............###########',
    '########.............###########',
    '########............############',
    '#######.............############',
    '#######.............############',
    '######.............#############',
    '######............##############',
    '#####............###############',
    '####............################',
    '####............################',
    '####............################',
    '###............#################',
    '###............#################',
    '###............#################',
  ];
  static const narrowCenterToNarrowLeft = [
    '###............#################',
    '###............#################',
    '###............#################',
    '####............################',
    '####............################',
    '#####............###############',
    '######............##############',
    '######.............#############',
    '#######.............############',
    '########............############',
    '########............############',
    '########.............###########',
    '#########............###########',
    '##########............##########',
    '##########............##########',
    '##########............##########',
  ];
  static const narrowCenterToNarrowRight = [
    '#################............###',
    '#################............###',
    '#################............###',
    '################............####',
    '################............####',
    '###############............#####',
    '##############............######',
    '#############.............######',
    '############.............#######',
    '############............########',
    '###########............#########',
    '###########............#########',
    '###########...........##########',
    '##########............##########',
    '##########............##########',
    '##########............##########',
  ];
  static const narrowRightToNarrowCenter = [
    '##########............##########',
    '##########............##########',
    '##########............##########',
    '###########...........##########',
    '###########...........##########',
    '###########............#########',
    '############............########',
    '############.............#######',
    '#############.............######',
    '#############.............######',
    '##############.............#####',
    '###############.............####',
    '################............####',
    '################............####',
    '#################............###',
    '#################............###',
  ];

  static const narrowLeftToNarrowRight = [
    '#################............###',
    '#################............###',
    '#################............###',
    '################............####',
    '################............####',
    '###############............#####',
    '##############............######',
    '#############.............######',
    '############.............#######',
    '############............########',
    '###########............#########',
    '###########...........##########',
    '###########...........##########',
    '##########............##########',
    '##########............##########',
    '##########............##########',
    '##########............##########',
    '##########............##########',
    '##########............##########',
    '#########............###########',
    '#########............###########',
    '#########............###########',
    '#########...........############',
    '########............############',
    '#######.............############',
    '######.............#############',
    '#####............###############',
    '####............################',
    '####............################',
    '####............################',
    '####............################',
    '###............#################',
    '###............#################',
    '###............#################',
  ];
  static const narrowRightToNarrowLeft = [
    '###............#################',
    '###............#################',
    '###............#################',
    '####............################',
    '####............################',
    '#####............###############',
    '######............##############',
    '######.............#############',
    '#######.............############',
    '########............############',
    '########............############',
    '#########............###########',
    '##########............##########',
    '##########............##########',
    '##########............##########',
    '##########............##########',
    '##########............##########',
    '##########............##########',
    '###########............#########',
    '###########............#########',
    '############............########',
    '#############............#######',
    '#############.............######',
    '#############.............######',
    '##############.............#####',
    '###############.............####',
    '################............####',
    '################............####',
    '#################............###',
    '#################............###',
  ];

  static const wideStraight = [
    '###..........................###',
    '###..........................###',
    '####.........................###',
    '####.........................###',
    '####........................####',
    '####........................####',
    '####........................####',
    '####........................####',
    '####........................####',
    '###.........................####',
    '###.........................####',
    '####.........................###',
    '####.........................###',
    '####.........................###',
    '####.........................###',
    '###..........................###',
  ];
  static const wideChicane = [
    '###..........................###',
    '###.........................####',
    '###........................#####',
    '###.......................######',
    '###......................#######',
    '###.....................########',
    '###....................#########',
    '####..................##########',
    '#####................###########',
    '######...............###########',
    '#######.............############',
    '#######............#############',
    '########..........##############',
    '########..........##############',
    '#########.........##############',
    '#########.........##############',
    '#########..........#############',
    '#########..........#############',
    '##########..........############',
    '##########...........###########',
    '###########...........##########',
    '###########............#########',
    '############............########',
    '############.............#######',
    '###########...............######',
    '##########.................#####',
    '#########..................#####',
    '########...................#####',
    '#######.....................####',
    '######......................####',
    '#####.......................####',
    '####........................####',
    '###.........................####',
  ];

  static const wideStraightIsland = [
    '###..........................###',
    '####........................####',
    '####........................####',
    '####.......................#####',
    '####.......................#####',
    '###.........................####',
    '###..........######.........####',
    '###........#########.........###',
    '###........##########........###',
    '###.........#########........###',
    '####........########.........###',
    '####.........######.........####',
    '####..........####.........#####',
    '####.......................#####',
    '#####......................#####',
    '#####......................#####',
    '#####.......................####',
    '####........................####',
    '###..........................###',
  ];
  static const wideStraightIsland2 = [
    '###..........................###',
    '####.........................###',
    '####........................####',
    '####........................####',
    '###...........###...........####',
    '###.........#######.........####',
    '###..........########........###',
    '###...........######.........###',
    '###..........######..........###',
    '###........#########.........###',
    '###........#########.........###',
    '###.........########.........###',
    '###.........########.........###',
    '###..........######..........###',
    '####..........##............####',
    '####........................####',
    '####.......................#####',
    '####.......................#####',
    '####........................####',
    '####.........................###',
    '###..........................###',
  ];
  static const wideStraightIsland3 = [
    '###..........................###',
    '####.........................###',
    '####........................####',
    '####........................####',
    '####..........###...........####',
    '###.........#######.........####',
    '###.........#######.........####',
    '###..........########........###',
    '###...........######.........###',
    '###..........######..........###',
    '###........#########.........###',
    '###........#########.........###',
    '###.........########.........###',
    '###.........########.........###',
    '###..........######.........####',
    '###..........#####..........####',
    '####.........#####..........####',
    '####..........#####..........###',
    '####..........#####..........###',
    '###..........####............###',
    '###..........###.............###',
    '###..........................###',
  ];
  static const wideToWideHourGlass = [
    '###..........................###',
    '###..........................###',
    '###..........................###',
    '####.........................###',
    '####........................####',
    '####........................####',
    '####........................####',
    '####........................####',
    '####........................####',
    '####........................####',
    '####.......................#####',
    '#####......................#####',
    '#####......................#####',
    '######....................######',
    '######....................######',
    '######....................######',
    '#######..................#######',
    '########.................#######',
    '########................########',
    '#########..............#########',
    '##########............##########',
    '##########............##########',
    '##########............##########',
    '##########.............#########',
    '#########..............#########',
    '########................########',
    '#######.................########',
    '######...................#######',
    '######....................######',
    '#####......................#####',
    '####........................####',
    '####.........................###',
    '###..........................###',
  ];

  static const wideSections = [
    wideStraight,
    wideToWideHourGlass,
    wideStraightIsland,
    wideStraightIsland2,
    wideStraightIsland3,
    wideChicane,
  ];

  static const narrowCenterStraight = [
    '##########............##########',
    '##########............##########',
    '##########............##########',
    '###########............#########',
    '###########............#########',
    '###########............#########',
    '##########............##########',
    '##########............##########',
    '##########............##########',
    '#########............###########',
    '#########............###########',
    '#########............###########',
    '#########.............##########',
    '##########............##########',
    '##########............##########',
    '##########............##########',
  ];
  static const narrowCenterStraightBendRight = [
    '##########............##########',
    '##########............##########',
    '##########.............#########',
    '##########.............#########',
    '###########............#########',
    '###########.............########',
    '###########.............########',
    '############............########',
    '############............########',
    '############............########',
    '############............########',
    '###########.............########',
    '###########.............########',
    '###########............#########',
    '##########.............#########',
    '##########.............#########',
    '##########.............#########',
    '##########............##########',
    '##########............##########',
  ];
  static const narrowCenterStraightBendLeft = [
    '##########............##########',
    '##########............##########',
    '#########.............##########',
    '#########.............##########',
    '#########.............##########',
    '########.............###########',
    '########.............###########',
    '#######.............############',
    '#######.............############',
    '#######.............############',
    '#######.............############',
    '#######..............###########',
    '########.............###########',
    '########.............###########',
    '#########.............##########',
    '#########.............##########',
    '#########.............##########',
    '##########............##########',
    '##########............##########',
  ];
  static const narrowCenterSnakeRight = [
    '##########............##########',
    '##########...........###########',
    '###########..........###########',
    '############..........##########',
    '##############..........########',
    '###############............#####',
    '################............####',
    '#################............###',
    '###################..........###',
    '###################..........###',
    '##################...........###',
    '##################...........###',
    '################............####',
    '##############.............#####',
    '#############.............######',
    '###########.............########',
    '##########...........###########',
    '########............############',
    '########...........#############',
    '#######............#############',
    '#######...........##############',
    '#######...........##############',
    '#######...........##############',
    '#######............#############',
    '#######............#############',
    '########............############',
    '########............############',
    '#########............###########',
    '#########.............##########',
    '##########............##########',
    '##########.............#########',
    '##########.............#########',
  ];

  static const narrowCenterSections = [
    narrowCenterStraight,
    narrowCenterSnakeRight,
    narrowCenterStraightBendRight,
    narrowCenterStraightBendLeft,
  ];

  static const narrowRightStraight = [
    '#################............###',
    '#################............###',
    '#################............###',
    '#################...........####',
    '#################...........####',
    '################...........#####',
    '################...........#####',
    '################...........#####',
    '################............####',
    '################............####',
    '#################...........####',
    '#################...........####',
    '##################...........###',
    '##################...........###',
    '#################............###',
    '#################............###',
  ];
  static const narrowRightStraightBendLeft = [
    '#################............###',
    '#################............###',
    '#################............###',
    '#################............###',
    '#################............###',
    '################............####',
    '################............####',
    '################............####',
    '################............####',
    '###############.............####',
    '###############.............####',
    '###############............#####',
    '###############............#####',
    '###############............#####',
    '###############............#####',
    '###############............#####',
    '###############............#####',
    '###############............#####',
    '###############............#####',
    '###############............#####',
    '################............####',
    '################............####',
    '################............####',
    '################............####',
    '################............####',
    '################............####',
    '#################...........####',
    '#################............###',
    '#################............###',
  ];

  static const narrowRightSections = [
    narrowRightStraight,
    narrowRightStraightBendLeft,
  ];
  static const narrowLeftStraight = [
    '###............#################',
    '###............#################',
    '###............#################',
    '###.............################',
    '###.............################',
    '####...........#################',
    '####...........#################',
    '###............#################',
    '###.............################',
    '###.............################',
    '###.............################',
    '####...........#################',
    '####...........#################',
    '###............#################',
    '###............#################',
    '###............#################',
  ];
  static const narrowLeftStraightBendRight = [
    '###............#################',
    '###............#################',
    '###............#################',
    '###.............################',
    '####............################',
    '####............################',
    '####............################',
    '####............################',
    '####............################',
    '####............################',
    '####.............###############',
    '#####............###############',
    '######............##############',
    '######............##############',
    '######............##############',
    '######............##############',
    '#####.............##############',
    '#####.............##############',
    '#####............###############',
    '#####............###############',
    '#####............###############',
    '####.............###############',
    '####............################',
    '####............################',
    '####............################',
    '####............################',
    '####...........#################',
    '###............#################',
    '###............#################',
  ];

  static const narrowLeftSections = [
    narrowLeftStraight,
    narrowLeftStraightBendRight,
  ];
}