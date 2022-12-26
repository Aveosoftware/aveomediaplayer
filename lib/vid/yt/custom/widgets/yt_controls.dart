part of 'package:aveoplayer/aveoplayer.dart';

class YTPlayerController extends StatefulWidget {
  final YoutubePlayerController ytController;
  const YTPlayerController({Key? key, required this.ytController})
      : super(key: key);

  @override
  _YTPlayerControllerState createState() => _YTPlayerControllerState();
}

class _YTPlayerControllerState extends State<YTPlayerController> {
  int sliderVal = 0;
  late Timer sliderRefresh;
  sliderValSetter() {
    sliderRefresh = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (widget.ytController.value.isPlaying && mounted) {
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    sliderValSetter();
    super.initState();
  }

  @override
  void dispose() {
    sliderRefresh.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: widget.ytController.value.isFullScreen
            ? MediaQuery.of(context).size.height
            : MediaQuery.of(context).size.width,
        height: widget.ytController.value.isFullScreen
            ? MediaQuery.of(context).padding.bottom + 91
            : 91,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Colors.transparent,
          Colors.black.withOpacity(0.5),
          Colors.black
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: AbsorbPointer(
          absorbing: !widget.ytController.value.isControlsVisible,
          child: Column(
            children: [
              SizedBox(
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        widget.ytController.toggleFullScreenMode();
                        widget.ytController.unMute();
                      },
                      icon: widget.ytController.value.isFullScreen
                          ? const Icon(
                              Icons.fullscreen_exit,
                              color: Colors.white,
                            )
                          : const Icon(
                              Icons.fullscreen,
                              color: Colors.white,
                            ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => showModalBottomSheet(
                          context: context,
                          builder: (_) => PlaybackSpeedYT(
                                controller: widget.ytController,
                              ),
                          backgroundColor: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'PS',
                          style: greetingStyle.copyWith(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: av.ProgressBar(
                  thumbRadius: 5,
                  thumbGlowRadius: 0,
                  thumbColor: Theme.of(context).primaryColor,
                  progressBarColor: Theme.of(context).primaryColor,
                  baseBarColor: const Color(0xff3E3D3D),
                  timeLabelTextStyle: progressStyle,
                  barHeight: Theme.of(context).sliderTheme.trackHeight ?? 3,
                  timeLabelLocation: av.TimeLabelLocation.sides,
                  timeLabelType: av.TimeLabelType.totalTime,
                  bufferedBarColor:
                      Theme.of(context).primaryColor.withOpacity(.4),
                  onSeek: (value) => widget.ytController.seekTo(value),
                  total: widget.ytController.metadata.duration,
                  progress: widget.ytController.value.position,
                  buffered: Duration(
                      seconds: widget.ytController.value.buffered.toInt()),
                ),
              ),
              SizedBox(
                height: widget.ytController.value.isFullScreen
                    ? MediaQuery.of(context).padding.bottom + 5
                    : 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
