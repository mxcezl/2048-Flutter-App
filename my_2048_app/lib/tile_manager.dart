import 'package:flutter/material.dart';
import 'main.dart';
import 'tile.dart';
import 'tile_types.dart';

class TileManager {
  static StatefulColorfulTile generateTileForInit() {
    Tile tileRandom = TileTypes.getRandomTileForGen();

    return StatefulColorfulTile(
        key: UniqueKey(),
        color: tileRandom.color,
        value: tileRandom.value,
        strValue: tileRandom.strValue);
  }

  // function that returns a list of tiles
  // for initialization of the game
  static generateInitList() {
    int initNumberTiles = 2;
    int numberOfEmptyTiles =
        (HomePageGameState.matriceSize * HomePageGameState.matriceSize) -
            initNumberTiles;

    List<Widget> tilesWithValues = List<Widget>.generate(initNumberTiles, (i) {
      return generateTileForInit();
    });

    List<Widget> blankTiles = List<Widget>.generate(numberOfEmptyTiles, (i) {
      return StatefulColorfulTile.emptyTile(UniqueKey());
    });

    List<Widget> returnList = tilesWithValues;
    returnList.addAll(blankTiles);
    returnList.shuffle();

    return returnList;
  }
}
