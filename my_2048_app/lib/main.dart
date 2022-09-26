import 'package:flutter/material.dart';
import 'action_manager.dart';
import 'tile_manager.dart';

Future<void> main() async {
  runApp(MaterialApp(
      home: HomePageGame(
    key: UniqueKey(),
  )));
}

class HomePageGame extends StatefulWidget {
  const HomePageGame({super.key});

  @override
  State<StatefulWidget> createState() => HomePageGameState();
}

class HomePageGameState extends State<HomePageGame> {
  late List<Widget> tiles;
  static const int matriceSize = 4;

  @override
  void initState() {
    super.initState();
    tiles = TileManager.generateInitList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      const SizedBox(
        height: 100,
      ),
      Container(
        alignment: Alignment.center,
        color: Colors.grey,
        child: GestureDetector(
          onVerticalDragEnd: (details) {
            if (details.velocity.pixelsPerSecond.dy < -250) {
              setState(() {
                tiles = ActionManager.performMovement(tiles, "UP");
              });
            } else if (details.velocity.pixelsPerSecond.dy > 250) {
              setState(() {
                tiles = ActionManager.performMovement(tiles, "DOWN");
              });
            }
          },
          onHorizontalDragEnd: (details) {
            if (details.velocity.pixelsPerSecond.dx < -500) {
              setState(() {
                tiles = ActionManager.performMovement(tiles, "LEFT");
              });
            } else if (details.velocity.pixelsPerSecond.dx > 500) {
              setState(() {
                tiles = ActionManager.performMovement(tiles, "RIGHT");
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
              mainAxisSpacing: 5,
              crossAxisCount: matriceSize,
              children: tiles),
        ),
      ),
      const SizedBox(
        height: 30,
      ),
    ]);
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
}

class ColorfulTileState extends State<StatefulColorfulTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
        ));
  }
}
