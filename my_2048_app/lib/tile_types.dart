import 'dart:math' show Random;
import 'package:flutter/material.dart';
import 'tile.dart';

class TileTypes {
  static Random random = Random();

  static Map<int, Color> initTiles = {
    2: const Color.fromRGBO(239, 229, 219, 1),
    4: const Color.fromRGBO(237, 225, 201, 1),
  };

  static Map<int, Color> tiles = {
    0: const Color.fromRGBO(205, 193, 179, 1),
    2: initTiles[2]!,
    4: initTiles[4]!,
    8: const Color.fromRGBO(243, 178, 122, 1),
    16: const Color.fromRGBO(246, 150, 100, 1),
    32: const Color.fromRGBO(244, 125, 98, 1),
    64: const Color.fromRGBO(244, 95, 62, 1),
    128: const Color.fromRGBO(238, 206, 116, 1),
    256: const Color.fromRGBO(238, 203, 98, 1),
    512: const Color.fromRGBO(238, 199, 82, 1),
    1024: const Color.fromRGBO(238, 196, 66, 1),
    2048: const Color.fromRGBO(239, 193, 47, 1),
  };

  static Tile getRandomTileForGen() {
    int generatedIndex = random.nextInt(initTiles.length);
    int valueFound = initTiles.keys.elementAt(generatedIndex);
    Color colorFound = initTiles[valueFound]!;

    return Tile(
        color: colorFound, value: valueFound, strValue: valueFound.toString());
  }
}
