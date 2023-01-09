part of 'package:aveoplayer/aveoplayer.dart';

class AveoVideoPlayer extends StatefulWidget {
  VideoPlayerController videoPlayerController;
  final bool autoplay;
  final Color overlayColor;

  ///will prvide this color to default bottomSheets like Playback speed
  final Color? bottomSheetColor;

  ///You can use this to give a linear gradient to controller overlay
  final List<double> overlayOpacity;

  final Future<ClosedCaptionFile>? closedCaptionFile;
  final VideoPlayerOptions? videoPlayerOptions;

  final Function? onComplete;

  ///These actions will be shown at top of Video
  final Widget Function(VideoPlayerController? videoplayerController)?
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
  AveoVideoPlayer(
      {Key? key,
      required this.videoPlayerController,
      this.onComplete,
      this.closedCaptionFile,
      this.videoPlayerOptions,
      required this.builder,
      this.autoplay = false,
      this.topActions,
      this.bottomActions,
      this.overlayColor = Colors.black,
      this.overlayOpacity = const [.5, .5],
      this.bottomSheetColor,
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
      this.onComplete,
      this.videoPlayerOptions,
      required this.builder,
      this.autoplay = false,
      this.topActions,
      this.bottomActions,
      this.overlayColor = Colors.black,
      this.overlayOpacity = const [.5, .5],
      this.bottomSheetColor,
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
      this.onComplete,
      this.autoplay = false,
      this.topActions,
      this.bottomActions,
      this.overlayColor = Colors.black,
      this.overlayOpacity = const [.5, .5],
      this.bottomSheetColor,
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
      this.topActions,
      this.onComplete,
      this.bottomActions,
      this.overlayColor = Colors.black,
      this.overlayOpacity = const [.5, .5],
      this.bottomSheetColor,
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
      this.topActions,
      this.onComplete,
      this.bottomActions,
      this.overlayColor = Colors.black,
      this.overlayOpacity = const [.5, .5],
      this.bottomSheetColor,
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
  void didUpdateWidget(AveoVideoPlayer oldWidget) {
    if (oldWidget.videoPlayerController.dataSource !=
        widget.videoPlayerController.dataSource) {
      oldWidget.videoPlayerController.dispose();
      reInitStates();
      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  void reInitStates() {
    state.addListener(() {});
    state.value = VPLoading();
    try {
      widget.videoPlayerController.initialize().then((_) {
        _videoPlayer = VideoStack(
          videoPlayerController: widget.videoPlayerController,
          aspectRatio: widget.videoPlayerController.value.aspectRatio,
          topActions: widget.topActions,
          bottomActions: widget.bottomActions,
          overlayColor: widget.overlayColor,
          overlayOpacity: widget.overlayOpacity,
          bottomSheetColor: widget.bottomSheetColor,
          onComplete: widget.onComplete,
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
  }

  @override
  void initState() {
    widget.videoPlayerController.addListener(() {
      if (widget.videoPlayerController.value.hasError) {
        state.value = VPError(
            error: widget.videoPlayerController.value.errorDescription ??
                'Something went wrong');
      }
    });
    reInitStates();
    super.initState();
  }

  @override
  void deactivate() {
    widget.videoPlayerController.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    // widget.videoPlayerController.removeListener(_onCompleteClosure);
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
            valueListenable: widget.videoPlayerController.isFullScreen,
            builder: ((context, value, child) {
              return value
                  ? WillPopScope(
                      onWillPop: () {
                        widget.videoPlayerController.toggleFullScreen(context);
                        return Future.value(false);
                      },
                      child: child!)
                  : widget.builder(context, temp is SizedBox ? child! : temp,
                      widget.videoPlayerController);
            }),
            child: _videoPlayer);
      },
    );
  }
}

typedef voidFunc = void Function();

TextStyle progressStyle = const TextStyle(
  fontSize: 9,
  fontWeight: FontWeight.w600,
  // height: 16,
  fontStyle: FontStyle.normal,
  color: Colors.white,
);
