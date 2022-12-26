part of 'package:aveoplayer/aveoplayer.dart';

class VideoStack extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final double aspectRatio;
  final Widget Function(VideoPlayerController videoplayerController)?
      topActions;
  final Widget Function(VideoPlayerController videoplayerController)?
      bottomActions;
  const VideoStack(
      {Key? key,
      required this.videoPlayerController,
      this.aspectRatio = 1,
      this.topActions,
      this.bottomActions})
      : super(key: key);

  @override
  State<VideoStack> createState() => _VideoStackState();
}

class _VideoStackState extends State<VideoStack>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;
  late Timer bufferCheckTimer;
  ValueNotifier<bool> showControls = ValueNotifier(true);
  ValueNotifier<bool> showLoader = ValueNotifier(true);

  dismissControls([bool init = false]) {
    if (!init) {
      animationController.reverse();
    }
    Future.delayed(const Duration(seconds: 3), () {
      showControls.value = false;
    });
  }

  buferChecker() {
    bufferCheckTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      showLoader.value = widget.videoPlayerController.value.isBuffering;
    });
  }

  @override
  void dispose() {
    animationController.stop();
    animationController.dispose();
    bufferCheckTimer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    showControls.addListener(() {
      if (showControls.value) {
        dismissControls();
      } else {
        if (mounted) {
          animationController.forward();
        }
      }
    });
    animationController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 1),
        reverseDuration: const Duration(seconds: 1));
    animation = Tween<double>(begin: 1, end: 0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeIn));
    dismissControls(true);
    buferChecker();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => showControls.value = !showControls.value,
        child: AspectRatio(
          aspectRatio: widget.aspectRatio,
          child: Stack(
            children: [
              VideoPlayer(
                widget.videoPlayerController,
              ),
              ValueListenableBuilder<bool>(
                valueListenable: showLoader,
                builder: (context, value, child) {
                  return Visibility(visible: value, child: child!);
                },
                child: const Center(
                  child: SizedBox.square(
                    dimension: 50,
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                child: FadeTransition(
                  opacity: animation,
                  child: ValueListenableBuilder<double>(
                    valueListenable: animation,
                    builder: (context, value, child) {
                      return AbsorbPointer(
                        absorbing: value < .5,
                        child: child,
                      );
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: widget.topActions
                              ?.call(widget.videoPlayerController) ??
                          const SizedBox.shrink(),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: FadeTransition(
                  opacity: animation,
                  child: ValueListenableBuilder<double>(
                    valueListenable: animation,
                    builder: (context, value, child) {
                      return AbsorbPointer(
                        absorbing: value < 0.5,
                        child: child,
                      );
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: widget.bottomActions
                              ?.call(widget.videoPlayerController) ??
                          DefaultBottomControls(
                              controller: widget.videoPlayerController),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
