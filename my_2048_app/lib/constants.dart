import 'package:flutter/material.dart';
import 'main.dart';

/// The inital number of tiles when the game starts.
const int initNumberTiles = 2;

/// String used for the UP direction.
const String directionUp = "UP";

/// String used for the DOWN direction.
const String directionDown = "DOWN";

/// String used for the LEFT direction.
const String directionLeft = "LEFT";

/// String used for the RIGHT direction.
const String directionRight = "RIGHT";

/// The key used by the [SharedPreferences] to store the highest score.
const String bestScoreKey = "BEST_SCORE_KEY";

/// The tile widget returned when no tile has been found at the given position.
const StatefulColorfulTile tileNotFound = StatefulColorfulTile(
  color: Colors.transparent,
  value: -1,
  strValue: "",
);
