import 'package:shared_preferences/shared_preferences.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constants.dart' as constants;
import 'grid_moved_result.dart';
import 'action_manager.dart';
import 'tile_manager.dart';
import 'tile_types.dart';

/// Preferences loaded from local device.
late SharedPreferences prefs;

/// The best score of the device user.
int bestScore = 0;

Future<void> main() async {
  runApp(MaterialApp(
    title: '2048',
    home: HomePageGame(
      key: UniqueKey(),
    ),
  ));
}

/// This class is the main page of the game.
class HomePageGame extends StatefulWidget {
  /// The constructor of the class.
  const HomePageGame({super.key});

  @override
  State<StatefulWidget> createState() => HomePageGameState();
}

/// This class is the state of the main page of the game.
class HomePageGameState extends State<HomePageGame> {
  /// The list of the tiles to be shown on the screen.
  late List<Widget> tiles;

  /// Size of the grid.
  static const int gridSize = 4;

  /// The score of the current game.
  int score = 0;

  /// This function is called when the state is created.
  @override
  void initState() {
    super.initState();
    getBestScore(); // Get the best score from the Shared Preferences.
    tiles =
        TileManager.generateInitList(); // Generate the initial list of tiles.
  }

  /// Function that gather the best score from the shared preferences.
  getBestScore() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      // Set the best score and update the state.
      bestScore = prefs.getInt(constants.bestScoreKey) ?? bestScore;
    });
  }

  /// Function that updates the best score from the shared preferences.
  updateBestScore() async {
    prefs = await SharedPreferences.getInstance();

    // Update the best score and save it in the shared preferences.
    prefs.setInt(constants.bestScoreKey, bestScore);
  }

  /// This function is called when the user swipe the screen.
  /// It will move the tiles in the direction of the swipe
  /// and add a new tile if possible.
  void _onSwipe(String direction) {
    // Perform the movement.
    GridMovedResult result = ActionManager.performMovement(tiles, direction);

    // If the grid has been changed, the score needs to be updated, as well as the tiles.
    if (result.isGridChanged) {
      setState(() {
        tiles = result.tiles;
        score += result.score;
        if (score > bestScore) {
          // Stting the new best score.
          bestScore = score;

          // Updating the best score in local.
          updateBestScore();
        }
      });
    }

    // If the game is finished, the user is asked if he wants to restart the game.
    if (result.isGameEnded) {
      _showEndGameDialog();
    }
  }

  /// This function is called when the state is built.
  @override
  Widget build(BuildContext context) {
    int sensitivity = 250; // Sensitivity of the vertical and horizontal swipes.
    double gridWidth =
        MediaQuery.of(context).size.width; // Width of the screen.
    gridWidth = gridWidth - (gridWidth * 0.07); // Remove 7% of the width.

    // Avoid the screen to rotate
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Container(
        color: const Color.fromRGBO(252, 249, 240, 1),
        alignment: Alignment.center,
        child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(50.0)),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                score.toString(),
                style: const TextStyle(
                  color: Color.fromRGBO(119, 110, 101, 1),
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Container(
                height: gridWidth,
                width: gridWidth,
                alignment: Alignment.center,
                color: const Color.fromRGBO(187, 173, 160, 1),
                child: GestureDetector(
                  onVerticalDragEnd: (details) {
                    if (details.velocity.pixelsPerSecond.dy < -sensitivity) {
                      _onSwipe(constants.directionUp);
                    } else if (details.velocity.pixelsPerSecond.dy >
                        sensitivity) {
                      _onSwipe(constants.directionDown);
                    }
                  },
                  onHorizontalDragEnd: (details) {
                    if (details.velocity.pixelsPerSecond.dx < -sensitivity) {
                      _onSwipe(constants.directionLeft);
                    } else if (details.velocity.pixelsPerSecond.dx >
                        sensitivity) {
                      _onSwipe(constants.directionRight);
                    }
                  },
                  child: GridView.count(
                      key: UniqueKey(),
                      shrinkWrap: true,
                      primary: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(10),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      crossAxisCount: gridSize,
                      children: tiles),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Meilleur score : ${bestScore.toString()}",
                      style: const TextStyle(
                        color: Color.fromRGBO(119, 110, 101, 1),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                      )),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(187, 173, 160, 1),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          score = 0;
                          tiles = TileManager.generateInitList();
                        });
                      },
                      child: const Text("Recommencer")),
                ],
              ),
            ])));
  }

  /// This function is called when the game is finished.
  /// It will show a dialog to the user to ask if he wants to restart the game.
  void _showEndGameDialog() {
    // Generating the text to be shown depending on the score obtained.
    late String endText;
    if (score == bestScore) {
      endText = "Nouveau meilleur score : ${score.toString()} !";
    } else {
      endText = "Votre score est de ${score.toString()}.";
    }

    // Showing the dialog.
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Game Over !"),
            content: Text(endText),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      score = 0;
                      tiles = TileManager.generateInitList();
                    });
                  },
                  child: const Text("Recommencer"))
            ],
          );
        });
  }
}

/// This class is used to manage the tiles.
class StatefulColorfulTile extends StatefulWidget {
  final Color color; // Background color of the tile.
  final int value; // Value of the tile.
  final String
      strValue; // String value of the tile to be shown (to avoid showing 0).

  /// Constructor of the StatefulColorfulTile.
  const StatefulColorfulTile(
      {Key? key,
      required this.color,
      required this.value,
      required this.strValue})
      : super(key: key);

  @override
  ColorfulTileState createState() => ColorfulTileState();

  /// Function that returns a blank tile.
  static StatefulColorfulTile emptyTile(Key key) {
    return StatefulColorfulTile(
      key: key,
      color: TileTypes.tiles[0]!,
      value: 0,
      strValue: "",
    );
  }

  /// This function is used to create a new tile from a given value and key.
  /// It will return a new tile with the corresponding color.
  /// If the value is not valid, it will return an empty tile.
  static StatefulColorfulTile fromValueTileWithKey(Key key, int value) {
    if (TileTypes.isTileInPresets(value)) {
      // If the value is in TileTypes.tiles, we return a tile with the corresponding tile.
      return StatefulColorfulTile(
          key: key,
          color: TileTypes.tiles[value]!,
          value: value,
          strValue: value.toString());
    } else if (TileTypes.isValueValidForTile(value)) {
      // If the value is not in TileTypes.tiles but is valid, we return a red tile
      // with the corresponding value.
      return StatefulColorfulTile(
          key: key,
          color: Colors.red,
          value: value,
          strValue: value.toString());
    } else {
      // Default case : return an empty tile.
      return StatefulColorfulTile.emptyTile(key);
    }
  }
}

/// This class is used to manage the state of the tiles.
class ColorfulTileState extends State<StatefulColorfulTile> {
  /// This function is used to update the state of the tile.
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        child: Container(
            key: UniqueKey(),
            color: widget.color,
            alignment: Alignment.center,
            child: AutoSizeText(
              widget.strValue,
              textAlign: TextAlign.center,
              maxLines: 1,
              presetFontSizes: const [50, 40, 20],
              style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 50,
                  color: TileTypes.getFontColor(widget.value),
                  backgroundColor: Colors.transparent),
            )));
  }
}
