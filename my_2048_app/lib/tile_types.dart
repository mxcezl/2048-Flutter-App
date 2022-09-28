import 'dart:math' show Random;
import 'package:flutter/material.dart';
import 'tile.dart';

class TileTypes {
  // for random choice of tiles
  static Random random = Random();

  // tiles that exists in game
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
    4096: const Color.fromRGBO(253, 62, 62, 1),
    8192: const Color.fromRGBO(252, 31, 32, 1),
  };

  /// function that returns a subset of the tiles map
  /// composed of tiles values 2 and 4 for the initialization.
  static Map<int, Color> getInitTiles() {
    return Map.fromEntries(
        tiles.entries.where((tile) => tile.key == 2 || tile.key == 4));
  }

  /// function that generates random tiles from the tiles map
  /// for the initialization of the game (only 2, 4 and empty tiles).
  static Tile getRandomTileForGen() {
    int generatedIndex = random.nextInt(getInitTiles().length);
    int randomValueFound = getInitTiles().keys.elementAt(generatedIndex);
    Color randomColorFound = getInitTiles()[randomValueFound]!;

    return Tile(
        color: randomColorFound,
        value: randomValueFound,
        strValue: randomValueFound.toString());
  }

  /// Function that returns true if the tile value exists in tiles possible
  /// values and false otherwise.
  /// This function is used to check if the tile value is valid.
  static bool isTileValueValid(int value) {
    return tiles.containsKey(value);
  }

  /// Function that returns true if the value is a power of 2 and false otherwise.
  /// This function is used to check if the tile value is valid in the game.
  static bool isValueValid(int value) {
    return (value & (value - 1)) == 0;
  }

  /// Function that returns the font color that should be shown on the tile
  /// depending on the tile value.
  /// Tiles with value 2 and 4 have a grey font color and white for the other tiles.
  static Color getFontColor(int value) {
    if (value == 2 || value == 4) {
      return const Color.fromRGBO(116, 107, 98, 1);
    }
    return const Color.fromRGBO(245, 245, 237, 1);
  }
}
