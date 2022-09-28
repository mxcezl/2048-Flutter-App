import 'package:flutter/material.dart';
import 'constants.dart' as constants;
import 'tile_types.dart';
import 'main.dart';
import 'tile.dart';

/// This class manages the tiles of the grid.
class TileManager {
  /// Function that generates an initial tile with value (2 or 4).
  static StatefulColorfulTile generateTileForInit() {
    Tile tileRandom = TileTypes.getRandomTileForGen();

    // Create a new tile with the given random value.
    return StatefulColorfulTile(
        key: UniqueKey(),
        color: tileRandom.color,
        value: tileRandom.value,
        strValue: tileRandom.strValue);
  }

  /// Function that returns a list of tiles
  /// for initialization of the game.
  static generateInitList() {
    // Calculate the number of empty tiles to generate.
    int numberOfEmptyTiles =
        (HomePageGameState.gridSize * HomePageGameState.gridSize) -
            constants.initNumberTiles;

    // Generates the initial tiles that have value.
    List<Widget> tilesWithValues =
        List<Widget>.generate(constants.initNumberTiles, (i) {
      return generateTileForInit();
    });

    // Generates the empty tiles.
    List<Widget> blankTiles = List<Widget>.generate(numberOfEmptyTiles, (i) {
      return StatefulColorfulTile.emptyTile(UniqueKey());
    });

    // Creates the list of tiles.
    List<Widget> returnList = tilesWithValues;
    returnList.addAll(blankTiles);
    returnList.shuffle(); // Randomize the list.

    return returnList;
  }
}
