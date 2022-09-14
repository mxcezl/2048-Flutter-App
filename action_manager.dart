import 'package:flutter/material.dart';
import 'main.dart';

class ActionManager {
  static moveGridToLeft(List<Widget> widgetList) {
    List<List<StatefulColorfulTile>> widgetMatrix =
        _convertListWidgetToMatrix(widgetList.cast<StatefulColorfulTile>());

    print("Column n° 0");
    print(_getColumnByIndex(0, widgetMatrix).map((e) => e.value).toList());
    print("Line n° 0");
    print(_getLineByIndex(0, widgetMatrix).map((e) => e.value).toList());
    // _printMatrix(widgetMatrix);
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

  static List<StatefulColorfulTile> _getLineByIndex(
      int index, List<List<StatefulColorfulTile>> matrix) {
    List<StatefulColorfulTile> lineWidget = [];
    for (var i = 0; i < 4; i++) {
      lineWidget.add(matrix[index][i]);
    }
    return lineWidget;
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
      String line = "";
      for (var j = 0; j < tileMatrix[i].length; j++) {
        int value = tileMatrix[i][j].value;
        if (value == 0) {
          line += ". ";
        } else {
          line += "${tileMatrix[i][j].strValue} ";
        }
      }
      print("${line}\n");
    }
  }
}
