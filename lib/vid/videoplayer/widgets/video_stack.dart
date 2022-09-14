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
  ValueNotifier<bool> showControls = ValueNotifier(true);

  dismissControls([bool init = false]) {
    if (!init) {
      animationController.reverse();
    }
    Future.delayed(const Duration(seconds: 3), () {
      showControls.value = false;
    });
  }

  @override
  void dispose() {
    animationController.stop();
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    showControls.addListener(() {
      if (showControls.value) {
        dismissControls();
      } else {
        animationController.forward();
      }
    });
    animationController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 1),
        reverseDuration: const Duration(seconds: 1));
    animation = Tween<double>(begin: 1, end: 0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeIn));
    dismissControls(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: AspectRatio(
        aspectRatio: widget.aspectRatio,
        child: Stack(
          children: [
            VideoPlayer(
              widget.videoPlayerController,
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                log('top');
                showControls.value = !showControls.value;
              },
            ),
            Positioned(
              top: 0,
              child: FadeTransition(
                opacity: animation,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  // height:
                  //     (widget.aspectRatio * MediaQuery.of(context).size.width) *
                  //         .2,
                  child:
                      widget.topActions?.call(widget.videoPlayerController) ??
                          const SizedBox.shrink(),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: FadeTransition(
                opacity: animation,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  // height: double.infinity * .3,
                  // (widget.aspectRatio * MediaQuery.of(context).size.width) *
                  //     .7,
                  child: widget.bottomActions
                          ?.call(widget.videoPlayerController) ??
                      DefaultBottomControls(
                          controller: widget.videoPlayerController),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
