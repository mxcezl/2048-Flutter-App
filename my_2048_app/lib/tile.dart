import 'dart:ui';

/// This class represents a tile without the rendering concept.
/// Only the value and the color are stored.
class Tile {
  late int value;
  late Color color;
  late String strValue;

  /// Creates a new [Tile] instance.
  Tile({required this.value, required this.color, required this.strValue});
}
