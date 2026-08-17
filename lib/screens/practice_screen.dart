import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kana_bus/barrel.dart';
import 'package:scribble/scribble.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  bool useBlack = false;
  List<int> activatedIndexes = [];
  Size gridDimensions = Size(5, 7);

  final GlobalKey<ScaffoldState> stageKey = GlobalKey<ScaffoldState>();

  late ScribbleNotifier notifier;

  @override
  void initState() {
    super.initState();
    notifier = ScribbleNotifier();
  }

  @override
  void dispose() {
    notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: stageKey,
      appBar: AppBar(
        title: Text('Practice'),
        leading: IconButton(
          icon: Icon(Icons.menu_book),
          onPressed: () {
            stageKey.currentState?.openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: () {
              if (gridDimensions.width > 1) {
                setState(() {
                  gridDimensions = Size(
                    gridDimensions.width - 1,
                    gridDimensions.height,
                  );
                });
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              setState(() {
                gridDimensions = Size(
                  gridDimensions.width + 1,
                  gridDimensions.height,
                );
              });
            },
          ),
          IconButton(
            icon: Icon(useBlack ? Icons.toggle_off : Icons.toggle_on),
            onPressed: () {
              setState(() {
                useBlack = !useBlack;
              });
            },
          ),
          IconButton(
            onPressed: () {
              clearGrid();
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      drawer: CustomDrawer(),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double height = constraints.maxHeight;
            double width = constraints.maxWidth;

            bool isPortrait = height > width;
            double dependDimension = isPortrait ? width : height;
            double gridUnitLength = width / gridDimensions.width;

            print('($width, $height)');
            print('dependDimension: $dependDimension');
            print('grid unit: ($gridUnitLength, $gridUnitLength)');

            // return Container(
            //   color: Colors.blue.shade100,
            //   height: 500,
            //   width: double.infinity,
            //   child: Scribble(notifier: notifier, drawPen: true),
            // );

            return Stack(
              children: [
                Positioned(
                  bottom: 0,
                  child: GestureDetector(
                    onTapDown: (details) => checkGridUnit(
                      gridUnitLength: gridUnitLength,
                      height: height,
                      tapDetails: details,
                    ),
                    onHorizontalDragUpdate: (details) => checkGridUnit(
                      gridUnitLength: gridUnitLength,
                      height: height,
                      dragDetails: details,
                    ),
                    onVerticalDragUpdate: (details) => checkGridUnit(
                      gridUnitLength: gridUnitLength,
                      height: height,
                      dragDetails: details,
                    ),
                    child: Container(
                      // height: height,
                      height: gridUnitLength * gridDimensions.height,
                      width: width,
                      color: isPortrait
                          ? Colors.red.shade100
                          : Colors.blue.shade100,
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: gridDimensions.width.toInt(),
                        ),
                        // gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        //   maxCrossAxisExtent: gridUnitLength,
                        //   // maxCrossAxisExtent: 50, // width / X = gridCount.width
                        //   // width = gridCount.width * X
                        //   // width / gridCount.width = x
                        // ),
                        physics: NeverScrollableScrollPhysics(),
                        // itemCount: ((height / gridUnitLength) * gridDimensions.width)
                        //     .toInt(),
                        itemCount:
                            (gridDimensions.width * gridDimensions.height)
                                .toInt(),
                        itemBuilder: (context, index) {
                          bool isTouched = activatedIndexes.contains(index);
                          // if (isTouched) {
                          //   print('touched at $index');
                          // }

                          return GridUnit(
                            // color: Colors.black,
                            color: useBlack ? Colors.black : getRandomColor(),
                            height: dependDimension / gridDimensions.height,
                            id: '$index',
                            isActivated: isTouched,
                            width: dependDimension / gridDimensions.width,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Color getRandomColor() {
    final Random random = Random();
    return Color.fromARGB(
      255, // Alpha (Full opacity)
      random.nextInt(256), // Red (0-255)
      random.nextInt(256), // Green (0-255)
      random.nextInt(256), // Blue (0-255)
    );
  }

  int getGridIndex({
    required double x,
    required double y,
    // required double gridWidth,
    // required double gridHeight,
    required double gridUnitLength,
    required int numCols,
    required int numRows,
  }) {
    final cellWidth = gridUnitLength; // gridWidth / numCols;
    final cellHeight = gridUnitLength; // gridHeight / numRows;

    final col = (x / cellWidth).floor().clamp(0, numCols - 1);
    final row = (y / cellHeight).floor().clamp(0, numRows - 1);

    return row * numCols + col;
  }

  void checkGridUnit({
    required double gridUnitLength,
    required double height,
    TapDownDetails? tapDetails,
    DragUpdateDetails? dragDetails,
  }) {
    if (dragDetails != null) {
      int gridIndex = getGridIndex(
        x: dragDetails.localPosition.dx,
        y: dragDetails.localPosition.dy,
        gridUnitLength: gridUnitLength,
        numCols: gridDimensions.width.toInt(),
        numRows: (height / gridUnitLength).toInt() + 1,
      );
      // print(gridIndex);
      if (!activatedIndexes.contains(gridIndex)) {
        setState(() {
          activatedIndexes.add(gridIndex);
        });
      }
    }
    if (tapDetails != null) {
      int gridIndex = getGridIndex(
        x: tapDetails.localPosition.dx,
        y: tapDetails.localPosition.dy,
        gridUnitLength: gridUnitLength,
        numCols: gridDimensions.width.toInt(),
        numRows: (height / gridUnitLength).toInt() + 1,
      );
      // print(gridIndex);
      if (!activatedIndexes.contains(gridIndex)) {
        setState(() {
          activatedIndexes.add(gridIndex);
        });
      }
    }
  }

  void clearGrid() {
    setState(() {
      activatedIndexes = [];
    });
  }
}

class GridUnit extends StatefulWidget {
  final bool isActivated;
  final bool? showText;
  final Color? borderColor;
  final Color? color;
  final double height;
  final double width;
  final String id;

  const GridUnit({
    super.key,
    required this.height,
    required this.id,
    required this.isActivated,
    required this.width,
    this.borderColor,
    this.color = Colors.transparent,
    this.showText = true,
  });

  @override
  State<GridUnit> createState() => _GridUnitState();
}

class _GridUnitState extends State<GridUnit> {
  late Color seededColor;

  @override
  void initState() {
    super.initState();

    seededColor = widget.color!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: widget.borderColor != null
            ? Border.all(color: widget.borderColor!)
            : null,
        color: widget.isActivated ? Colors.transparent : widget.color,
      ),
      height: widget.height,
      width: widget.width,
      child: widget.showText!
          ? Center(
              child: Text(widget.id, style: TextStyle(color: Colors.black45)),
            )
          : null,
    );
  }
}
