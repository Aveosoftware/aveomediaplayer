part of 'package:aveoplayer/aveoplayer.dart';

class AveoVideoPlayer extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool autoplay;

  ///This key will be assigned to internal Video player widget
  final Key? playerKey;
  final Future<ClosedCaptionFile>? closedCaptionFile;
  final VideoPlayerOptions? videoPlayerOptions;

  ///These actions will be shown at top of Video
  final Widget Function(VideoPlayerController videoplayerController)?
      topActions;

  ///These actions will be shown at bottom of Video
  final Widget Function(VideoPlayerController videoplayerController)?
      bottomActions;

  ///Add your page structure here
  final Widget Function(BuildContext context, Widget player,
      VideoPlayerController videoPlayerController) builder;

  ///This widget will be shown while the video is being loaded or initaialized in place of ```player```
  final Widget placeHolder;

  ///This widget will be shown when there is any error, it will replace ```player```
  final Widget Function(String error)? errorWidget;

  ///This Widget provides it's own scaffold, therefore use it as root Widget of your page.
  ///
  ///and use it's builder method to populate rest of the page and place ```player``` wherever you desire
  const AveoVideoPlayer(
      {Key? key,
      required this.videoPlayerController,
      this.closedCaptionFile,
      this.videoPlayerOptions,
      required this.builder,
      this.autoplay = false,
      this.playerKey,
      this.topActions,
      this.bottomActions,
      this.placeHolder = const DefaultLoading(),
      this.errorWidget})
      : super(key: key);

  ///This Widget provides it's own scaffold, therefore use it as root Widget of your page.
  ///
  ///and use it's builder method to populate rest of the page and place ```player``` wherever you desire
  ///## URL must be https. as http is not allowed by android
  AveoVideoPlayer.network(
      {Key? key,
      required String uri,
      VideoFormat? formatHint,
      Map<String, String> httpHeaders = const <String, String>{},
      this.closedCaptionFile,
      this.videoPlayerOptions,
      required this.builder,
      this.autoplay = false,
      required this.playerKey,
      this.topActions,
      this.bottomActions,
      this.placeHolder = const DefaultLoading(),
      this.errorWidget})
      : videoPlayerController = VideoPlayerController.network(uri,
            formatHint: formatHint,
            httpHeaders: httpHeaders,
            closedCaptionFile: closedCaptionFile,
            videoPlayerOptions: videoPlayerOptions),
        assert(uri.contains('https://')),
        super(key: key);

  ///This Widget provides it's own scaffold, therefore use it as root Widget of your page.
  ///
  ///and use it's builder method to populate rest of the page and place ```player``` wherever you desire
  AveoVideoPlayer.file(
      {Key? key,
      required File file,
      this.closedCaptionFile,
      this.videoPlayerOptions,
      required this.builder,
      this.autoplay = false,
      required this.playerKey,
      this.topActions,
      this.bottomActions,
      this.placeHolder = const DefaultLoading(),
      this.errorWidget})
      : videoPlayerController = VideoPlayerController.file(file,
            closedCaptionFile: closedCaptionFile,
            videoPlayerOptions: videoPlayerOptions),
        super(key: key);

  ///This Widget provides it's own scaffold, therefore use it as root Widget of your page.
  ///
  ///and use it's builder method to populate rest of the page and place ```player``` wherever you desire
  AveoVideoPlayer.asset(
      {Key? key,
      required String uri,
      String? package,
      this.closedCaptionFile,
      this.videoPlayerOptions,
      required this.builder,
      this.autoplay = false,
      required this.playerKey,
      this.topActions,
      this.bottomActions,
      this.placeHolder = const DefaultLoading(),
      this.errorWidget})
      : videoPlayerController = VideoPlayerController.asset(uri,
            package: package,
            closedCaptionFile: closedCaptionFile,
            videoPlayerOptions: videoPlayerOptions),
        super(key: key);

  ///This Widget provides it's own scaffold, therefore use it as root Widget of your page.
  ///
  ///and use it's builder method to populate rest of the page and place ```player``` wherever you desire
  ///# Android Only
  AveoVideoPlayer.contentURI(
      {Key? key,
      required Uri uri,
      this.closedCaptionFile,
      this.videoPlayerOptions,
      required this.builder,
      this.autoplay = false,
      required this.playerKey,
      this.topActions,
      this.bottomActions,
      this.placeHolder = const DefaultLoading(),
      this.errorWidget})
      : videoPlayerController = VideoPlayerController.contentUri(uri,
            closedCaptionFile: closedCaptionFile,
            videoPlayerOptions: videoPlayerOptions),
        super(key: key);

  @override
  State<AveoVideoPlayer> createState() => AveoVideoPlayerState();
}

class AveoVideoPlayerState extends State<AveoVideoPlayer> {
  Widget _videoPlayer = const DefaultLoading();

  ValueNotifier<VideoPlayerState> state = ValueNotifier(_VPInit());

  @override
  void initState() {
    state.addListener(() {
      log('state: ${state.value}');
    });

    state.value = VPLoading();
    try {
      widget.videoPlayerController.initialize().then((_) {
        log('Aspect Ratio: ${widget.videoPlayerController.value.aspectRatio} : isInit: ${widget.videoPlayerController.value.isInitialized}');
        _videoPlayer = VideoStack(
          videoPlayerController: widget.videoPlayerController,
          aspectRatio: widget.videoPlayerController.value.aspectRatio,
          topActions: widget.topActions,
          bottomActions: widget.bottomActions,
          playerKey: widget.playerKey,
        );
        setState(() {});
        if (widget.autoplay) {
          widget.videoPlayerController.play();
        }
      });
      state.value = VPSuccess();
    } catch (e) {
      state.value = VPError(error: e.toString());
      log(e.toString());
    }
    super.initState();
  }

  @override
  void deactivate() {
    widget.videoPlayerController.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    widget.videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<VideoPlayerState>(
      valueListenable: state,
      builder: (context, status, _) {
        Widget temp = const SizedBox.shrink();
        if (status is VPError) {
          if (widget.videoPlayerController.value.isPlaying) {
            widget.videoPlayerController.pause();
          }
          temp = widget.errorWidget?.call(status.error) ??
              DefaultError(error: status.error);
        } else if (status is VPLoading) {
          if (widget.videoPlayerController.value.isPlaying) {
            widget.videoPlayerController.pause();
          }
          temp = widget.placeHolder;
        }

        return ValueListenableBuilder<bool>(
            valueListenable: widget.videoPlayerController.isFullScreen(),
            builder: ((context, value, child) {
              return value
                  ? child!
                  : widget.builder(context, temp is SizedBox ? child! : temp,
                      widget.videoPlayerController);
            }),
            child: _videoPlayer);
      },
    );
  }
}

class VideoStack extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final Key? playerKey;
  final double aspectRatio;
  final Widget Function(VideoPlayerController videoplayerController)?
      topActions;
  final Widget Function(VideoPlayerController videoplayerController)?
      bottomActions;
  const VideoStack(
      {Key? key,
      required this.videoPlayerController,
      this.aspectRatio = 1,
      this.playerKey,
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
              key: widget.playerKey,
            ),
            FadeTransition(
              opacity: animation,
              child: Positioned(
                top: 0,
                child: FractionallySizedBox(
                  widthFactor: 1,
                  heightFactor: .2,
                  child:
                      widget.topActions?.call(widget.videoPlayerController) ??
                          const SizedBox.shrink(),
                ),
              ),
            ),
            FadeTransition(
              opacity: animation,
              child: Positioned(
                bottom: 0,
                child: FractionallySizedBox(
                  widthFactor: 1,
                  heightFactor: .3,
                  child: widget.bottomActions
                          ?.call(widget.videoPlayerController) ??
                      const SizedBox.shrink(),
                ),
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                log('top');
                showControls.value = !showControls.value;
              },
            ),
          ],
        ),
      ),
    );
  }
}

extension Features on VideoPlayerController {
  @internal
  static final ValueNotifier<bool> _fullscr = ValueNotifier(false);
  ValueListenable<bool> isFullScreen() => _fullscr;

  // Stream<double> currentPosition(
  //     {Duration interval = const Duration(seconds: 1),
  //     bool forSeek = true}) async* {
  //   int total = value.duration.inSeconds;
  //   int current = 0;
  //   Timer.periodic(interval, (timer) async* {
  //     current = (await position)?.inSeconds??0;
  //     if (forSeek) {
  //       yield current/total;
  //     }
  //   });
  // }

  toggleFullScreen(BuildContext context) {
    if (!kIsWeb) {
      if (value.aspectRatio <= 1) {
        _fullscr.value = !_fullscr.value;
        _fullscr.value
            ? SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky)
            : SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                overlays: SystemUiOverlay.values);
      } else {
        if (MediaQuery.of(context).orientation == Orientation.portrait) {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight
          ]);
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

          _fullscr.value = true;
        } else {
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
              overlays: SystemUiOverlay.values);

          _fullscr.value = false;
        }
      }
    }
  }
}

class DefaultLoading extends StatelessWidget {
  const DefaultLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AspectRatio(
      aspectRatio: 16 / 9,
      child: ColoredBox(
        color: Colors.black,
        child: Center(
            child: SizedBox.square(
                dimension: 60,
                child: CircularProgressIndicator(color: Color(0xb1ffffff)))),
      ),
    );
  }
}

class DefaultError extends StatelessWidget {
  final String error;
  const DefaultError({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ColoredBox(
        color: Colors.black,
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.info,
              color: Color(0x77ffffff),
            ),
            const SizedBox.square(
              dimension: 10,
            ),
            Text(
              error,
              style: const TextStyle(color: Color(0x99ffffff)),
            )
          ],
        )),
      ),
    );
  }
}

class DefaultBottomControls extends StatefulWidget {
  final VideoPlayerController controller;
  const DefaultBottomControls({Key? key, required this.controller})
      : super(key: key);

  @override
  State<DefaultBottomControls> createState() => _DefaultBottomControlsState();
}

class _DefaultBottomControlsState extends State<DefaultBottomControls> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

abstract class VideoPlayerState {}

class VPError extends VideoPlayerState {
  final String error;
  VPError({required this.error});
}

class VPLoading extends VideoPlayerState {}

class VPSuccess extends VideoPlayerState {}

class _VPInit extends VideoPlayerState {}
