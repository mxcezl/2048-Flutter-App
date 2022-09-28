import 'package:flutter/material.dart';
import 'main.dart';

/// This class represents the result of a grid move.
class GridMovedResult {
  /// The score obtained after the move.
  final int score;

  /// The grid after the move.
  final List<Widget> tiles;

  /// Indicates if the grid has changed after the move.
  final bool isGridChanged;

  /// Indicates if the game is over.
  final bool isGameEnded;

  /// Creates a new [GridMovedResult] instance.
  GridMovedResult(this.score, this.tiles, this.isGridChanged, this.isGameEnded);

  /// Creates a new [GridMovedResult] instance with the given [score] and [tiles].
  /// The [isGridChanged] and [isGameEnded] fields are set to false.
  /// This function is used only for sending the score and the grid.
  static GridMovedResult resultAfterMove(
      int score, List<StatefulColorfulTile> widgetList) {
    return GridMovedResult(score, widgetList.cast<Widget>(), true, false);
  }
}
