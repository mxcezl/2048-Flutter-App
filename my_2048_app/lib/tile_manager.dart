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

  static generateInitList() {
    int initNumberTiles = 2;
    int numberOfEmptyTiles =
        (HomePageGameState.matriceSize * HomePageGameState.matriceSize) -
            initNumberTiles;

    var tilesWithValues = List<Widget>.generate(initNumberTiles, (i) {
      return generateTileForInit();
    });

    var blankTiles = List<Widget>.generate(numberOfEmptyTiles, (i) {
      return StatefulColorfulTile(
          key: UniqueKey(), color: TileTypes.tiles[0]!, value: 0, strValue: "");
    });

    var returnList = tilesWithValues;
    returnList.addAll(blankTiles);
    returnList.shuffle();

    return returnList;
  }
}
