import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'grid_moved_result.dart';
import 'tile_manager.dart';
import 'tile_types.dart';
import 'main.dart';
import 'constants.dart' as Constants;

class ActionManager {
  static GridMovedResult performMovement(
      List<Widget> widgetList, String direction) {
    List<List<StatefulColorfulTile>> widgetMatrix =
        _convertListWidgetToMatrix(widgetList.cast<StatefulColorfulTile>());
    int score = 0;
    switch (direction) {
      case Constants.LEFT:
        {
          if (kDebugMode) {
            print(Constants.LEFT);
          }
          for (var line in widgetMatrix) {
            GridMovedResult result = moveTilesInGrid(line);
            line = result.tiles.cast<StatefulColorfulTile>();
            score += result.score;
          }
        }
        break;
      case Constants.RIGHT:
        {
          if (kDebugMode) {
            print(Constants.RIGHT);
          }
          int i = 0;
          for (var line in widgetMatrix.map((e) => e.reversed.toList())) {
            GridMovedResult result = moveTilesInGrid(line);
            widgetMatrix[i] =
                result.tiles.cast<StatefulColorfulTile>().reversed.toList();
            score += result.score;
            i++;
          }
        }
        break;
      case Constants.UP:
        {
          if (kDebugMode) {
            print(Constants.UP);
          }
          for (int i = 0; i < widgetMatrix.length; i++) {
            List<StatefulColorfulTile> columnIndexI =
                _getColumnByIndex(i, widgetMatrix);
            GridMovedResult result = moveTilesInGrid(columnIndexI);
            score += result.score;
            columnIndexI = result.tiles.cast<StatefulColorfulTile>();

            for (int j = 0; j < columnIndexI.length; j++) {
              widgetMatrix[j][i] = columnIndexI[j];
            }
          }
        }
        break;
      case Constants.DOWN:
        {
          if (kDebugMode) {
            print(Constants.DOWN);
          }
          for (int i = 0; i < widgetMatrix.length; i++) {
            List<StatefulColorfulTile> columnIndexI =
                _getColumnByIndex(i, widgetMatrix).reversed.toList();

            GridMovedResult result = moveTilesInGrid(columnIndexI);
            score += result.score;
            columnIndexI =
                result.tiles.cast<StatefulColorfulTile>().reversed.toList();

            for (int j = 0; j < columnIndexI.length; j++) {
              widgetMatrix[j][i] = columnIndexI[j];
            }
          }
        }
        break;
    }
    widgetList = widgetMatrix.expand((element) => element).toList();
    widgetList = _addTileAfterAMove(widgetList);
    return GridMovedResult(score, widgetList);
  }

  static GridMovedResult moveTilesInGrid(
      List<StatefulColorfulTile> widgetList) {
    int score = 0;
    for (int i = 0; i < widgetList.length; i++) {
      for (int j = i; j < widgetList.length; j++) {
        if (widgetList[j].value != 0) {
          StatefulColorfulTile mergeTile = widgetList.skip(j + 1).firstWhere(
              (t) => t.value != 0,
              orElse: () => Constants.TILE_NOT_FOUND);

          int indexTileToMerge = widgetList.indexOf(mergeTile);
          bool foundOtherTile = false;
          if (mergeTile.value != 99) foundOtherTile = true;

          bool mustMerge = true;
          if (!foundOtherTile || mergeTile.value != widgetList[j].value) {
            mustMerge = false;
          }

          if (i != j || mustMerge) {
            int resultValue = widgetList[j].value;
            if (mustMerge) {
              resultValue += mergeTile.value;
              widgetList[indexTileToMerge] = StatefulColorfulTile.emptyTile(
                  widgetList[indexTileToMerge].key!, TileTypes.tiles[0]!);
              score += resultValue;
            }

            widgetList[j] = StatefulColorfulTile.emptyTile(
                widgetList[j].key!, TileTypes.tiles[0]!);

            widgetList[i] = StatefulColorfulTile(
                key: widgetList[i].key,
                color: TileTypes.tiles[resultValue]!,
                value: resultValue,
                strValue: resultValue.toString());
          }
          break;
        }
      }
    }
    return GridMovedResult(score, widgetList);
  }

  static List<List<StatefulColorfulTile>> _convertListWidgetToMatrix(
      List<StatefulColorfulTile> widgetList) {
    List<List<StatefulColorfulTile>> tileMatrix = [];
    int chunkSize = 4;
    List<StatefulColorfulTile> list = widgetList.cast<StatefulColorfulTile>();
    for (var i = 0; i < list.length; i += chunkSize) {
      tileMatrix.add(list.sublist(
          i, i + chunkSize > list.length ? list.length : i + chunkSize));
    }
    return tileMatrix;
  }

  static List<StatefulColorfulTile> _getColumnByIndex(
      int index, List<List<StatefulColorfulTile>> matrix) {
    List<StatefulColorfulTile> columnWidget = [];
    for (var i = 0; i < 4; i++) {
      columnWidget.add(matrix[i][index]);
    }
    return columnWidget;
  }

  static List<Widget> _addTileAfterAMove(List<Widget> widgetList) {
    List<StatefulColorfulTile> emptyTiles =
        widgetList.cast<StatefulColorfulTile>();

    emptyTiles = emptyTiles.where((tile) => tile.value == 0).toList();
    emptyTiles.shuffle();
    StatefulColorfulTile tileToReplace = emptyTiles.first;

    int indexToReplace = widgetList.indexOf(tileToReplace);

    widgetList[indexToReplace] = TileManager.generateTileForInit();

    return widgetList;
  }
}
