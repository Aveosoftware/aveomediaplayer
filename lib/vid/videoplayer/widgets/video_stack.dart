part of 'package:aveoplayer/aveoplayer.dart';

class VideoStack extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final double aspectRatio;
  final Color overlayColor;
  final Color? bottomSheetColor;
  final List<double> overlayOpacity;
  final Function? onComplete;
  final Widget Function(VideoPlayerController videoplayerController)?
      topActions;
  final Widget Function(VideoPlayerController videoplayerController)?
      bottomActions;
  const VideoStack(
      {Key? key,
      required this.videoPlayerController,
      this.aspectRatio = 1,
      this.topActions,
      required this.overlayColor,
      required this.overlayOpacity,
      this.onComplete,
      this.bottomSheetColor,
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

  bool onCompleteCalled = false;

  voidFunc get _onCompleteClosure => () {
        try {
          if (!widget.videoPlayerController.value.isLooping) {
            if (mounted) {
              int position =
                  widget.videoPlayerController.value.position.inSeconds;
              int duration =
                  widget.videoPlayerController.value.duration.inSeconds;

              print('log: position: $position duration: $duration');
              print('log: ${widget.videoPlayerController.dataSource}');
              if (widget.videoPlayerController.value.position.inSeconds ==
                      widget.videoPlayerController.value.duration.inSeconds &&
                  !onCompleteCalled) {
                onCompleteCalled = true;
                widget.onComplete?.call();
              }
              if (onCompleteCalled &&
                  widget.videoPlayerController.value.position.inSeconds !=
                      widget.videoPlayerController.value.duration.inSeconds) {
                onCompleteCalled = false;
              }
            }
          }
        } catch (_) {
          onCompleteCalled = true;
          widget.onComplete?.call();
        }
      };

  @override
  void dispose() {
    animationController.stop();
    animationController.dispose();
    bufferCheckTimer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    widget.videoPlayerController.addListener(_onCompleteClosure);
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
              FadeTransition(
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
                    height: MediaQuery.of(context).size.height,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: List.generate(
                                  widget.overlayOpacity.length,
                                  (index) => widget.overlayColor.withOpacity(
                                      widget.overlayOpacity[index])),
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter)),
                    ),
                  ),
                ),
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
                              bottomSheetColor: widget.bottomSheetColor,
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
