import 'package:flutter/material.dart';
import 'tile_manager.dart';
import 'tile_types.dart';
import 'main.dart';

class ActionManager {
  static List<Widget> performMovement(
      List<Widget> widgetList, String direction) {
    List<List<StatefulColorfulTile>> widgetMatrix =
        _convertListWidgetToMatrix(widgetList.cast<StatefulColorfulTile>());

    switch (direction) {
      case "LEFT":
        {
          for (var line in widgetMatrix) {
            line = moveTilesInGrid(line);
          }
        }
        break;
      case "RIGHT":
        {
          int i = 0;
          for (var line in widgetMatrix.map((e) => e.reversed.toList())) {
            widgetMatrix[i] = moveTilesInGrid(line).reversed.toList();
            i++;
          }
        }
        break;
      case "UP":
        {
          for (int i = 0; i < widgetMatrix.length; i++) {
            List<StatefulColorfulTile> columnIndexI =
                _getColumnByIndex(i, widgetMatrix);
            columnIndexI = moveTilesInGrid(columnIndexI);
            for (int j = 0; j < columnIndexI.length; j++) {
              widgetMatrix[j][i] = columnIndexI[j];
            }
          }
        }
        break;
      case "DOWN":
        {
          for (int i = 0; i < widgetMatrix.length; i++) {
            List<StatefulColorfulTile> columnIndexI =
                _getColumnByIndex(i, widgetMatrix).reversed.toList();
            columnIndexI = moveTilesInGrid(columnIndexI).reversed.toList();
            for (int j = 0; j < columnIndexI.length; j++) {
              widgetMatrix[j][i] = columnIndexI[j];
            }
          }
        }
        break;
    }
    widgetList = widgetMatrix.expand((element) => element).toList();
    // widgetList = _addTileAfterAMove(widgetList);
    return widgetList;
  }

  static List<StatefulColorfulTile> moveTilesInGrid(
      List<StatefulColorfulTile> widgetList) {
    for (int i = 0; i < widgetList.length; i++) {
      for (int j = i; j < widgetList.length; j++) {
        if (widgetList[j].value != 0) {
          StatefulColorfulTile mergeTile =
              widgetList.skip(j + 1).firstWhere((t) => t.value != 0,
                  orElse: () => const StatefulColorfulTile(
                        color: Colors.transparent,
                        value: 99,
                        strValue: "",
                      ));

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
              widgetList[indexTileToMerge] = StatefulColorfulTile(
                  key: widgetList[indexTileToMerge].key,
                  color: TileTypes.tiles[0]!,
                  value: 0,
                  strValue: "");
            }

            widgetList[j] = StatefulColorfulTile(
                key: widgetList[j].key,
                color: TileTypes.tiles[0]!,
                value: 0,
                strValue: "");
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
    return widgetList;
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

  static void _printMatrix(List<List<StatefulColorfulTile>> tileMatrix) {
    for (var i = 0; i < tileMatrix.length; i++) {
      _printLine(tileMatrix[i]);
    }
  }

  static void _printLine(List<StatefulColorfulTile> tileList) {
    String line = "";
    for (var i = 0; i < tileList.length; i++) {
      int value = tileList[i].value;
      if (value == 0) {
        line += ". ";
      } else {
        line += "${tileList[i].strValue} ";
      }
    }
    print(line);
  }
}

List<Widget> _addTileAfterAMove(List<Widget> widgetList) {
  List<StatefulColorfulTile> emptyTiles =
      widgetList.cast<StatefulColorfulTile>();
  emptyTiles.retainWhere((tile) => tile.value == 0);
  emptyTiles.shuffle();
  StatefulColorfulTile tileToReplace = emptyTiles.first;
  int indexToReplace = widgetList.indexOf(tileToReplace);
  widgetList[indexToReplace] = TileManager.generateTileForInit();
  return widgetList;
}
