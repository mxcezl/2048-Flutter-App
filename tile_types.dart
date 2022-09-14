import 'dart:math' show Random;
import 'package:flutter/material.dart';
import 'tile.dart';

class TileTypes {
  static Random random = Random();

  static Map<int, Color> initTiles = {
    2: Colors.yellow.shade400,
    4: Colors.yellow.shade600,
  };

  static Map<int, Color> tiles = {
    2: Colors.yellow.shade400,
    4: Colors.yellow.shade600,
    8: Colors.yellow.shade800,
    16: Colors.orange.shade400,
    32: Colors.orange.shade600,
    64: Colors.orange.shade800,
    128: Colors.orange.shade900,
    256: Colors.red.shade400,
    512: Colors.red.shade600,
    1024: Colors.red.shade800,
    2048: Colors.greenAccent,
  };

  static Tile getRandomTileForGen() {
    int generatedIndex = random.nextInt(initTiles.length);
    int valueFound = initTiles.keys.elementAt(generatedIndex);
    Color colorFound = initTiles[valueFound]!;

    return Tile(
        color: colorFound, value: valueFound, strValue: valueFound.toString());
  }
}
