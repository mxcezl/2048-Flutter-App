import 'dart:math' show Random;
import 'package:flutter/material.dart';
import 'tile.dart';

class TileTypes {
  static Random random = Random();

  static Map<int, Color> tiles = {
    0: const Color.fromRGBO(205, 193, 179, 1),
    2: const Color.fromRGBO(239, 229, 219, 1),
    4: const Color.fromRGBO(237, 225, 201, 1),
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

  // static function that returns a subset of the tiles map composed of values 2 and 4
  static Map<int, Color> getInitTiles() {
    return Map.fromEntries(
        tiles.entries.where((element) => element.key == 2 || element.key == 4));
  }

  static Tile getRandomTileForGen() {
    int generatedIndex = random.nextInt(getInitTiles().length);
    int valueFound = getInitTiles().keys.elementAt(generatedIndex);
    Color colorFound = getInitTiles()[valueFound]!;

    return Tile(
        color: colorFound, value: valueFound, strValue: valueFound.toString());
  }
}
