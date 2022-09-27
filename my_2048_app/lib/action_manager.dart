import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'grid_moved_result.dart';
import 'tile_manager.dart';
import 'tile_types.dart';
import 'main.dart';

// ignore: library_prefixes
import 'constants.dart' as Constants;

class ActionManager {
  /// This function is called when the user swipe the screen.
  /// It will move the tiles in the direction of the swipe
  /// and add a new tile if possible.
  /// This function also check if the game is ended and save the score.
  static GridMovedResult performMovement(
      List<Widget> widgetList, String direction) {
    int gridHash = _getGridHash(widgetList);
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

    bool isGameChanged = gridHash != _getGridHash(widgetList);
    if (isGameChanged) {
      widgetList = _addTileAfterAMove(widgetList);
    }

    return GridMovedResult(
        score, widgetList, isGameChanged, _isGameEnd(widgetList));
  }

  /// Function that takes a list of tile and move them while performing a merge
  /// if possible.
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
                  widgetList[indexTileToMerge].key!);
              score += resultValue;
            }

            widgetList[j] = StatefulColorfulTile.emptyTile(widgetList[j].key!);

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
    return GridMovedResult.resultAfterMove(score, widgetList);
  }

  /// Converts a list of widgets to a matrix of widgets.
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

  /// Returns column at index [index] from a widget matrix.
  static List<StatefulColorfulTile> _getColumnByIndex(
      int index, List<List<StatefulColorfulTile>> matrix) {
    List<StatefulColorfulTile> columnWidget = [];
    for (var i = 0; i < 4; i++) {
      columnWidget.add(matrix[i][index]);
    }
    return columnWidget;
  }

  /// Function that adds a tile to the grid after a move if possible
  /// and returns the new list of tiles.
  static List<Widget> _addTileAfterAMove(List<Widget> widgetList) {
    List<StatefulColorfulTile> widgetListCasted =
        widgetList.cast<StatefulColorfulTile>();

    List<StatefulColorfulTile> emptyTiles = getEmptyTiles(widgetListCasted);
    emptyTiles.shuffle();

    // not empty && changed grid
    if (emptyTiles.isNotEmpty) {
      StatefulColorfulTile tileToReplace = emptyTiles.first;
      int indexTileToReplace = widgetListCasted.indexOf(tileToReplace);
      widgetList[indexTileToReplace] = TileManager.generateTileForInit();
    }

    if (_isGameEnd(widgetList)) {
      // Show pop-up
      // Save the score if best score
      // Restart game
    }

    return widgetList;
  }

  /// Function that returns all the empty tiles in the grid.
  static List<StatefulColorfulTile> getEmptyTiles(
      List<StatefulColorfulTile> widgetList) {
    return widgetList.where((tile) => tile.value == 0).toList();
  }

  /// Function that returns true if the game is over and lase otherwise.
  /// The game is over if there are no empty tiles and no possible moves.
  static bool _isGameEnd(List<Widget> widgetList) {
    List<StatefulColorfulTile> widgetListCasted =
        widgetList.cast<StatefulColorfulTile>();

    List<StatefulColorfulTile> emptyTiles = getEmptyTiles(widgetListCasted);
    if (emptyTiles.isNotEmpty) {
      return false;
    }

    return !_checkIfMergePossible(_convertListWidgetToMatrix(widgetListCasted));
  }

  /// Function that returns true if a merge is possible in the grid false otherwise.
  /// A merge is possible if two tiles with the same value are next to each other
  /// in the same row or column.
  static bool _checkIfMergePossible(
      List<List<StatefulColorfulTile>> widgetMatrix) {
    for (int i = 0; i < widgetMatrix.length; i++) {
      for (int j = 0; j < widgetMatrix[i].length; j++) {
        if (i < widgetMatrix.length - 1) {
          if (widgetMatrix[i][j].value == widgetMatrix[i + 1][j].value) {
            return true;
          }
        }
        if (j < widgetMatrix[i].length - 1) {
          if (widgetMatrix[i][j].value == widgetMatrix[i][j + 1].value) {
            return true;
          }
        }
      }
    }
    return false;
  }

  /// Function that returns a list of tiles as a string.
  static String _listWidgetToString(List<Widget> widgetList) {
    List<StatefulColorfulTile> widgetListCasted =
        widgetList.cast<StatefulColorfulTile>();
    String str = "";
    for (var i = 0; i < widgetListCasted.length; i++) {
      str += "${widgetListCasted[i].value} ";
    }
    return str;
  }

  /// Function that generates a unique hash from a string.
  static int _generateHashFromString(String str) {
    int hash = 0;
    for (int i = 0; i < str.length; i++) {
      hash = 31 * hash + str.codeUnitAt(i);
    }
    return hash;
  }

  /// Function that returns a hash of the current grid.
  /// The hash is used to check if the grid has changed after a move.
  static int _getGridHash(List<Widget> widgetList) {
    return _generateHashFromString(_listWidgetToString(widgetList));
  }
}
