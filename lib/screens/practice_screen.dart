import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kana_bus/barrel.dart';
import 'package:scribble/scribble.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  bool showKana = false;
  // bool useBlack = true;
  List<int> activatedIndexes = [];
  List<int> currentCharacter = [];
  Size gridDimensions = Size(9, 9); // Size(5, 7);

  final GlobalKey<ScaffoldState> stageKey = GlobalKey<ScaffoldState>();

  late ScribbleNotifier notifier;

  @override
  void initState() {
    super.initState();
    notifier = ScribbleNotifier();

    currentCharacter = MisakiGothicHiragana7x7.aAt9x9;
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
        // leading: IconButton(
        //   icon: Icon(Icons.menu),
        //   onPressed: () {
        //     stageKey.currentState?.openDrawer();
        //   },
        // ),
        automaticallyImplyLeading: false,
        actions: buildAppBarActions(),
      ),
      endDrawer: CustomDrawer(),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double height = constraints.maxHeight;
            double width = constraints.maxWidth;

            bool isPortrait = height > width;
            double dependDimension = isPortrait ? width : height;
            double gridUnitLength = width / gridDimensions.width;
            double infoSectionHeight =
                height - gridUnitLength * gridDimensions.height;

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
                  top: 0,
                  child: Container(
                    // color: Colors.green.shade100,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    height: infoSectionHeight,
                    width: width,
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            InkWell(
                              onTap: () {
                                print('next character');
                              },
                              child: SizedBox(
                                height: infoSectionHeight - 35,
                                width: 50,
                                // color: Colors.red.shade100,
                                child: Icon(
                                  Icons.chevron_left,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // SizedBox(height: 15),
                            Text('a', style: TextStyle(fontSize: width / 5)),
                            SizedBox(height: 15),
                            showKana
                                ? RichText(
                                    text: TextSpan(
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyLarge,
                                      children: [
                                        TextSpan(
                                          text: 'あ',
                                          style: TextStyle(fontSize: width / 5),
                                        ),
                                        TextSpan(
                                          text: '  ',
                                          style: TextStyle(fontSize: width / 5),
                                        ),
                                        TextSpan(
                                          text: 'あ',
                                          style: TextStyle(
                                            fontFamily: 'MisakiGothic',
                                            fontSize: width / 5,
                                          ),
                                          // TODO: on tap, shimmer the grid (?)
                                          // recognizer: TapGestureRecognizer()
                                          //   ..onTap = () {
                                          //     setState(() {});
                                          //   },
                                        ),
                                      ],
                                    ),
                                  )
                                // Text(
                                //     'あ',
                                //     style: TextStyle(
                                //       fontFamily: 'MisakiGothic',
                                //        fontSize: width / 10),
                                //   )
                                : HyperlinkText(
                                    onTap: () {
                                      setState(() {
                                        showKana = true;
                                      });
                                    },
                                    text: 'Show Kana',
                                    style: TextStyle(fontSize: width / 20),
                                  ),
                          ],
                        ),
                        Column(
                          children: [
                            InkWell(
                              onTap: () {
                                print('next character');
                              },
                              child: SizedBox(
                                height: infoSectionHeight - 35,
                                width: 50,
                                // color: Colors.blue.shade100,
                                child: Icon(
                                  Icons.chevron_right,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
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
                      padding: EdgeInsets.zero,
                      // height: height,
                      height: gridUnitLength * gridDimensions.height,
                      width: width,
                      // color: isPortrait
                      //     ? Colors.red.shade100
                      //     : Colors.blue.shade100,
                      // color:
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
                          bool isInCharacter = currentCharacter.contains(index);

                          return GridUnit(
                            // borderColor: useBlack
                            //     ? Colors.white.withAlpha(155)
                            //     : Colors.transparent,
                            borderColor: isTouched
                                ? Colors.white.withAlpha(155)
                                : null,
                            // color: Colors.black,
                            // color: useBlack ? Colors.black : getRandomColor(),
                            color: Theme.of(
                              context,
                            ).primaryColor.withAlpha(200),
                            height: dependDimension / gridDimensions.height,
                            id: '$index',
                            isActivated: isTouched,
                            isInCharacter: isInCharacter,
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

  List<Widget> buildAppBarActions() {
    return [
      // IconButton(
      //   icon: Icon(Icons.remove),
      //   onPressed: () {
      //     if (gridDimensions.width > 1) {
      //       setState(() {
      //         gridDimensions = Size(
      //           gridDimensions.width - 1,
      //           gridDimensions.height,
      //         );
      //       });
      //     }
      //   },
      // ),
      // IconButton(
      //   icon: Icon(Icons.add),
      //   onPressed: () {
      //     setState(() {
      //       gridDimensions = Size(
      //         gridDimensions.width + 1,
      //         gridDimensions.height,
      //       );
      //     });
      //   },
      // ),
      // IconButton(
      //   icon: Icon(useBlack ? Icons.toggle_off : Icons.toggle_on),
      //   onPressed: () {
      //     setState(() {
      //       useBlack = !useBlack;
      //     });
      //   },
      // ),
      IconButton(
        onPressed: () {
          clearGrid();
          setState(() {
            showKana = false;
          });
        },
        icon: Icon(Icons.refresh),
      ),
      IconButton(
        icon: Icon(Icons.menu),
        onPressed: () {
          stageKey.currentState?.openEndDrawer();
        },
      ),
    ];
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
  final bool isInCharacter;
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
    required this.isInCharacter,
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
        color: widget.isActivated
            ? widget.isInCharacter
                  ? Colors.white54
                  : Colors.transparent
            : widget.color,
      ),
      margin: EdgeInsets.all(10),
      height: widget.height,
      width: widget.width,
      child: widget.showText!
          ? Center(
              child: Text(
                widget.id,
                style: TextStyle(
                  color: widget.isActivated
                      ? widget.isInCharacter
                            ? Colors.black54
                            : Colors.white12
                      : Theme.of(context).colorScheme.inverseSurface,
                ),
              ),
            )
          : null,
    );
  }
}
