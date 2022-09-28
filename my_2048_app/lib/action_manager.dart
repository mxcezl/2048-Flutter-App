import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'constants.dart' as constants;
import 'grid_moved_result.dart';
import 'tile_manager.dart';
import 'main.dart';

/// This class manages the actions of the game.
class ActionManager {
  /// This function is called when the user swipe the screen.
  /// It will move the tiles in the direction of the swipe
  /// and add a new tile if possible.
  /// This function also check if the game is ended and save the score.
  static GridMovedResult performMovement(
      List<Widget> widgetList, String direction) {
    // Get the hash of the current state of the grid.
    int gridHash = _getGridHash(widgetList);

    // Converts the list into a 2D array.
    List<List<StatefulColorfulTile>> widgetMatrix =
        _convertListWidgetToMatrix(widgetList.cast<StatefulColorfulTile>());

    // Counter for the score made with this move.
    int score = 0;

    // Depending on the direction requested, we will call differently the
    // function that will move the tiles.
    switch (direction) {
      case constants.directionLeft: // <== Left
        {
          if (kDebugMode) print("Direction : ${constants.directionLeft}");

          for (var line in widgetMatrix) {
            GridMovedResult result = moveTiles(line);
            line = result.tiles.cast<StatefulColorfulTile>();
            score += result.score;
          }
        }
        break;
      case constants.directionRight: // ==> Right
        {
          if (kDebugMode) print("Direction : ${constants.directionRight}");

          int i = 0;
          for (var line in widgetMatrix.map((e) => e.reversed.toList())) {
            GridMovedResult result = moveTiles(line);
            widgetMatrix[i] =
                result.tiles.cast<StatefulColorfulTile>().reversed.toList();
            score += result.score;
            i++;
          }
        }
        break;
      case constants.directionUp: // ^ Up
        {
          if (kDebugMode) print("Direction : ${constants.directionUp}");

          for (int i = 0; i < widgetMatrix.length; i++) {
            List<StatefulColorfulTile> columnIndexI =
                _getColumnByIndex(i, widgetMatrix);
            GridMovedResult result = moveTiles(columnIndexI);
            score += result.score;
            columnIndexI = result.tiles.cast<StatefulColorfulTile>();

            for (int j = 0; j < columnIndexI.length; j++) {
              widgetMatrix[j][i] = columnIndexI[j];
            }
          }
        }
        break;
      case constants.directionDown: // V Down
        {
          if (kDebugMode) print("Direction : ${constants.directionDown}");

          for (int i = 0; i < widgetMatrix.length; i++) {
            List<StatefulColorfulTile> columnIndexI =
                _getColumnByIndex(i, widgetMatrix).reversed.toList();

            GridMovedResult result = moveTiles(columnIndexI);
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

    // When the actions has been done, we convert our 2D array into a list.
    widgetList = widgetMatrix.expand((element) => element).toList();

    // If the hash of the grid before the actions is different from the current hash
    // then it means that the grid has changed and we can add a new tile.
    bool isGameChanged = gridHash != _getGridHash(widgetList);
    if (isGameChanged) {
      widgetList = _addTile(widgetList);
    }

    // Return the state of the grid after the move.
    return GridMovedResult(
        score, widgetList, isGameChanged, _isGameEnd(widgetList));
  }

  /// Function that takes a list of tile (line or column in the grid) and move
  /// them while performing a merge if possible.
  static GridMovedResult moveTiles(List<StatefulColorfulTile> widgetList) {
    int score = 0;

    // We will iterate over the list and move the tiles.
    for (int i = 0; i < widgetList.length; i++) {
      for (int j = i; j < widgetList.length; j++) {
        // If the tile is not empty, we will try to move it.
        if (widgetList[j].value != 0) {
          // Find a tile that is not empty and that is not the same tile.
          // If we find one, we will try to merge them.
          // If we can't merge them, we will move the tile to the position of the
          // first empty tile.
          StatefulColorfulTile tileInTheSameLine = widgetList
              .skip(j + 1)
              .firstWhere((t) => t.value != 0,
                  orElse: () => constants.tileNotFound);

          // Check if there is another tile in the line that is not empty.
          bool foundOtherTile = false;
          if (tileInTheSameLine.value != constants.tileNotFound.value) {
            foundOtherTile = true;
          }

          // If there is a tile in the same line, next to the one we're checking,
          // and they have the same value, we will merge them.
          bool mustMerge = true;
          if (!foundOtherTile ||
              tileInTheSameLine.value != widgetList[j].value) {
            mustMerge = false;
          }

          // If we must merge the tiles, we will do it.
          // If not, we will move the tile to the first empty tile.
          if (i != j || mustMerge) {
            int currentTileValue =
                widgetList[j].value; // Value of the tile we're checking.

            // Performing the merge.
            if (mustMerge) {
              int indexTileToMerge = widgetList.indexOf(tileInTheSameLine);
              currentTileValue += tileInTheSameLine
                  .value; // New value of the tile that will be merged.
              widgetList[indexTileToMerge] = StatefulColorfulTile.emptyTile(
                  widgetList[indexTileToMerge].key!); // Empty the tile merged.
              score += currentTileValue; // Update the score.
            }
            // Empty the tile used to merge.
            widgetList[j] = StatefulColorfulTile.emptyTile(widgetList[j].key!);

            // Creating the merged tile.
            widgetList[i] = StatefulColorfulTile.fromValueTileWithKey(
                widgetList[i].key!, currentTileValue);
          }
          break;
        }
      }
    }
    // Return the list of tiles and the score made with this move.
    return GridMovedResult.resultAfterMove(score, widgetList);
  }

  /// Converts a list of widgets to a 2D array of widgets.
  static List<List<StatefulColorfulTile>> _convertListWidgetToMatrix(
      List<StatefulColorfulTile> widgetList) {
    List<List<StatefulColorfulTile>> tile2DArray = [];
    int chunkSize = 4;
    List<StatefulColorfulTile> list = widgetList.cast<StatefulColorfulTile>();

    // Split the list into chunks of 4.
    for (var i = 0; i < list.length; i += chunkSize) {
      // Add the chunk to the 2D array.
      tile2DArray.add(list.sublist(
          i, i + chunkSize > list.length ? list.length : i + chunkSize));
    }
    return tile2DArray;
  }

  /// Returns column at index [index] from a widget matrix.
  static List<StatefulColorfulTile> _getColumnByIndex(
      int index, List<List<StatefulColorfulTile>> matrix) {
    List<StatefulColorfulTile> columnWidget = [];

    for (var i = 0; i < 4; i++) {
      // Add the tile to the column.
      columnWidget.add(matrix[i][index]);
    }
    return columnWidget;
  }

  /// Function that adds a tile to the grid after a move if possible
  /// and returns the new list of tiles.
  static List<Widget> _addTile(List<Widget> widgetList) {
    List<StatefulColorfulTile> widgetListCasted =
        widgetList.cast<StatefulColorfulTile>();

    // Get the list of empty tiles.
    List<StatefulColorfulTile> emptyTiles = getEmptyTiles(widgetListCasted);

    // If there is enough space in the grid, we will add a new tile.
    if (emptyTiles.isNotEmpty) {
      emptyTiles.shuffle(); // Randomize the list of empty tiles.
      StatefulColorfulTile tileToReplace =
          emptyTiles.first; // Get the first tile.
      int indexTileToReplace = widgetListCasted
          .indexOf(tileToReplace); // Get the index of the empty tile.

      // Create a new tile with a random value (2 or 4).
      widgetList[indexTileToReplace] = TileManager.generateTileForInit();
    }

    // Return the new list of tiles.
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

    // If there is at least one empty tile, the game is not over.
    if (getEmptyTiles(widgetListCasted).isNotEmpty) {
      return false;
    }

    // If there is no empty tile, we will check if there is a possible move.
    // We will check if there is a tile that can be merged with another one.
    // If there is, the game is not over.
    return !_checkIfMergePossible(_convertListWidgetToMatrix(widgetListCasted));
  }

  /// Function that returns true if a merge is possible in the grid false otherwise.
  /// A merge is possible if two tiles with the same value are next to each other
  /// in the same row or column.
  static bool _checkIfMergePossible(
      List<List<StatefulColorfulTile>> widgetMatrix) {
    // We will check if there is a tile that can be merged with another one.
    // That means that there is a tile that has the same value as another tile
    // in the same row or column and next to each other.
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
    // If not, there is no possible move.
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
  /// This hash will be used to compare the game state.
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
