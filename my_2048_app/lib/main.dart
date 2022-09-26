import 'package:flutter/material.dart';
import 'action_manager.dart';
import 'tile_manager.dart';

Future<void> main() async {
  runApp(MaterialApp(
      title: '2048',
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
    int sensitivity = 250;
    double width = MediaQuery.of(context).size.width;
    width = width - (width * 0.05);
    return Container(
        color: const Color.fromRGBO(252, 249, 240, 1),
        alignment: Alignment.center,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          child: Container(
            height: width,
            width: width,
            alignment: Alignment.center,
            color: const Color.fromRGBO(187, 173, 160, 1),
            child: GestureDetector(
              onVerticalDragEnd: (details) {
                if (details.velocity.pixelsPerSecond.dy < -sensitivity) {
                  setState(() {
                    tiles = ActionManager.performMovement(tiles, "UP");
                  });
                } else if (details.velocity.pixelsPerSecond.dy > sensitivity) {
                  setState(() {
                    tiles = ActionManager.performMovement(tiles, "DOWN");
                  });
                }
              },
              onHorizontalDragEnd: (details) {
                if (details.velocity.pixelsPerSecond.dx < -sensitivity) {
                  setState(() {
                    tiles = ActionManager.performMovement(tiles, "LEFT");
                  });
                } else if (details.velocity.pixelsPerSecond.dx > sensitivity) {
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
                  mainAxisSpacing: 10,
                  crossAxisCount: matriceSize,
                  children: tiles),
            ),
          ),
        ));
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
