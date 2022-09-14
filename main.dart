import 'package:flutter/material.dart';
import 'tile.dart' show Tile;
import 'tile_types.dart';

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
        child: GridView.count(
            shrinkWrap: true,
            padding: const EdgeInsets.all(10),
            crossAxisSpacing: 10,
            mainAxisSpacing: 5,
            crossAxisCount: matriceSize,
            children: tiles),
      ),
      const SizedBox(
        height: 30,
      ),
      Container(
        alignment: Alignment.center,
        color: Colors.yellow,
        child: GridView.count(
            shrinkWrap: true,
            padding: const EdgeInsets.all(10),
            crossAxisSpacing: 10,
            mainAxisSpacing: 5,
            crossAxisCount: 4,
            children: [
              RawMaterialButton(
                onPressed: () {},
                fillColor: Colors.white,
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.arrow_left,
                  size: 30,
                ),
              ),
              RawMaterialButton(
                onPressed: () {},
                fillColor: Colors.white,
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.arrow_downward,
                  size: 30,
                ),
              ),
              RawMaterialButton(
                onPressed: () {},
                fillColor: Colors.white,
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.arrow_upward,
                  size: 30,
                ),
              ),
              RawMaterialButton(
                onPressed: () {},
                fillColor: Colors.white,
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.arrow_right,
                  size: 30,
                ),
              ),
            ]),
      )
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
        color: widget.color,
        child: Text(
          widget.strValue,
          textAlign: TextAlign.center,
          style: const TextStyle(
              decoration: TextDecoration.none,
              fontSize: 60,
              color: Colors.black,
              backgroundColor: Colors.transparent),
        ));
  }
}

class TileManager {
  static StatefulColorfulTile _generateTileForInit() {
    Tile tileRandom = TileTypes.getRandomTileForGen();

    return StatefulColorfulTile(
        key: UniqueKey(),
        color: tileRandom.color,
        value: tileRandom.value,
        strValue: tileRandom.strValue);
  }

  static generateInitList() {
    int initNumberTiles = 2;
    int numberOfEmptyTiles =
        (HomePageGameState.matriceSize * HomePageGameState.matriceSize) -
            initNumberTiles;

    var tilesWithValues = List<Widget>.generate(initNumberTiles, (i) {
      return _generateTileForInit();
    });

    var blankTiles = List<Widget>.generate(numberOfEmptyTiles, (i) {
      return StatefulColorfulTile(
          key: UniqueKey(), color: Colors.transparent, value: 0, strValue: "");
    });

    var returnList = tilesWithValues;
    returnList.addAll(blankTiles);
    returnList.shuffle();

    return returnList;
  }
}
