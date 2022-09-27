import 'package:flutter/material.dart';
import 'package:my_2048_app/grid_moved_result.dart';
import 'action_manager.dart';
import 'tile_manager.dart';

Future<void> main() async {
  runApp(MaterialApp(
    title: '2048',
    home: HomePageGame(
      key: UniqueKey(),
    ),
  ));
}

class HomePageGame extends StatefulWidget {
  const HomePageGame({super.key});

  @override
  State<StatefulWidget> createState() => HomePageGameState();
}

class HomePageGameState extends State<HomePageGame> {
  late List<Widget> tiles;
  static const int matriceSize = 4;
  int score = 0;

  @override
  void initState() {
    super.initState();
    tiles = TileManager.generateInitList();
  }

  @override
  Widget build(BuildContext context) {
    int sensitivity = 250;
    double width = MediaQuery.of(context).size.width;
    width = width - (width * 0.05);
    return Container(
        color: const Color.fromRGBO(252, 249, 240, 1),
        alignment: Alignment.center,
        child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
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
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Container(
                height: width,
                width: width,
                alignment: Alignment.center,
                color: const Color.fromRGBO(187, 173, 160, 1),
                child: GestureDetector(
                  onVerticalDragEnd: (details) {
                    if (details.velocity.pixelsPerSecond.dy < -sensitivity) {
                      setState(() {
                        GridMovedResult result =
                            ActionManager.performMovement(tiles, "UP");
                        tiles = result.tiles;
                        score += result.score;
                      });
                    } else if (details.velocity.pixelsPerSecond.dy >
                        sensitivity) {
                      setState(() {
                        GridMovedResult result =
                            ActionManager.performMovement(tiles, "DOWN");
                        tiles = result.tiles;
                        score += result.score;
                      });
                    }
                  },
                  onHorizontalDragEnd: (details) {
                    if (details.velocity.pixelsPerSecond.dx < -sensitivity) {
                      setState(() {
                        GridMovedResult result =
                            ActionManager.performMovement(tiles, "LEFT");
                        tiles = result.tiles;
                        score += result.score;
                      });
                    } else if (details.velocity.pixelsPerSecond.dx >
                        sensitivity) {
                      setState(() {
                        GridMovedResult result =
                            ActionManager.performMovement(tiles, "RIGHT");
                        tiles = result.tiles;
                        score += result.score;
                      });
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
                      crossAxisCount: matriceSize,
                      children: tiles),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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
                      child: const Text("Restart")),
                  SizedBox(
                      width: (MediaQuery.of(context).size.width - width) / 2),
                ],
              ),
            ])));
  }
}

class StatefulColorfulTile extends StatefulWidget {
  final Color color;
  final int value;
  final String strValue;

  const StatefulColorfulTile(
      {Key? key,
      required this.color,
      required this.value,
      required this.strValue})
      : super(key: key);

  @override
  ColorfulTileState createState() => ColorfulTileState();

  static StatefulColorfulTile emptyTile(Key key, Color color) {
    return StatefulColorfulTile(
      key: key,
      color: color,
      value: 0,
      strValue: "",
    );
  }
}

class ColorfulTileState extends State<StatefulColorfulTile> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        child: Container(
            key: UniqueKey(),
            color: widget.color,
            alignment: Alignment.center,
            child: Text(
              widget.strValue,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 50,
                  color: Colors.black,
                  backgroundColor: Colors.transparent),
            )));
  }
}
