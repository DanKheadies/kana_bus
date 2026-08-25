import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class CustomLoadingWidget extends StatefulWidget {
  final double? size;

  const CustomLoadingWidget({super.key, this.size = 200});

  @override
  State<CustomLoadingWidget> createState() => _CustomLoadingWidgetState();
}

class _CustomLoadingWidgetState extends State<CustomLoadingWidget>
    with TickerProviderStateMixin {
  bool hasData = false;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();

    timeDilation = 3;
    // Note: not sure what effect changing the time dilation will have on other
    // things, e.g. Snackbar, Bloc state change, etc. Should be aight.
    // Update: this affects speed of Snackbar display, but not the overall
    // duration it remains on the screen.

    animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _playAnimation();
  }

  Future<void> _playAnimation() async {
    try {
      await animationController.forward().orCancel;
    } on TickerCanceled {
      // The animation got canceled, probably because it was disposed of.
      timeDilation = 1;
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        // color: Theme.of(context).colorScheme.primary,
        height: widget.size,
        width: widget.size,
        child: Stack(
          children: [
            // WaveAnimationWidget(
            //   controller: animationController,
            //   heightPercentages: [0.3, 0.375, 0.45, 0.525],
            //   screenSize: MediaQuery.of(context).size,
            // ),
            Container(
              color: Colors.transparent,
              height: widget.size,
              width: widget.size,
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
                strokeWidth: widget.size! / 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
