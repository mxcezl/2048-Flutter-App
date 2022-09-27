import 'package:flutter/material.dart';
import 'package:my_2048_app/main.dart';

class GridMovedResult {
  final int score;
  final List<Widget> tiles;
  final bool isGridChanged;
  final bool isGameEnded;

  GridMovedResult(this.score, this.tiles, this.isGridChanged, this.isGameEnded);

  static GridMovedResult resultAfterMove(
      int score, List<StatefulColorfulTile> widgetList) {
    return GridMovedResult(score, widgetList.cast<Widget>(), true, false);
  }
}
