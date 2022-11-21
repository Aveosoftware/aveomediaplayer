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
  sliderValSetter() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (widget.ytController.value.isPlaying && mounted) {
        setState(() {
          sliderVal = ((widget.ytController.value.position.inSeconds /
                      widget.ytController.metadata.duration.inSeconds) *
                  100)
              .toInt();
        });
      }
    });
  }

  @override
  void initState() {
    sliderValSetter();
    super.initState();
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
              // const SizedBox(
              //   height: 5,
              // ),
              SizedBox(
                child: Row(
                  children: [
                    // Expanded(
                    //   flex: 2,
                    //   child: IconButton(
                    //       onPressed: () {
                    //         // print(
                    //         //     'video value: ${playerController.videoNo.value}');
                    //         if (playerController.videoNo.value != 0) {
                    //           playerController.videoNo.value--;
                    //           playerController.nextIsYT.value = playerController
                    //                   .videos[playerController.videoNo.value]
                    //                   .url
                    //                   .contains('vimeo')
                    //               ? false
                    //               : true;
                    //           playerController.queue();
                    //         }
                    //       },
                    //       icon: Icon(
                    //         Icons.skip_previous,
                    //         size: 30,
                    //         color: playerController.videoNo.value == 0
                    //             ? Colors.grey
                    //             : Colors.white,
                    //       )),
                    // ),
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
                    // Expanded(
                    //   flex: 2,
                    //   child: IconButton(
                    //       onPressed: () {
                    //         // print(
                    //         //     'video value: ${playerController.videoNo.value}');
                    //         if (playerController.videoNo.value <
                    //             playerController.videos.length - 1) {
                    //           // widget.ytController.seekTo(Duration(
                    //           //     seconds: widget.ytController.value.metaData
                    //           //         .duration.inSeconds));
                    //           playerController.videoNo.value++;
                    //           playerController.queue();
                    //         }
                    //       },
                    //       icon: Icon(
                    //         Icons.skip_next,
                    //         size: 30,
                    //         color: playerController.videoNo.value ==
                    //                 playerController.videos.length - 1
                    //             ? Colors.grey
                    //             : Colors.white,
                    //       )),
                    // ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                child: Row(
                  children: [
                    Text(
                      '  ${printDuration(widget.ytController.value.position)}/${printDuration(widget.ytController.metadata.duration)}',
                      style: progressStyle,
                    ),
                    const Spacer(
                      flex: 1,
                    ),
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
                child: SliderTheme(
                  data: SliderThemeData(
                      trackShape: CustomTrackShape(),
                      overlayShape: SliderComponentShape.noThumb,
                      thumbShape: const RoundSliderThumbShape(
                          pressedElevation: 0, enabledThumbRadius: 5),
                      trackHeight: 2),
                  child: Slider(
                    min: 0,
                    max: 100,
                    // divisions: 100,
                    value: sliderVal.toDouble(),
                    thumbColor: Theme.of(context).primaryColor,
                    activeColor: Theme.of(context).primaryColor,
                    inactiveColor: Color(0xff3E3D3D),
                    onChanged: (double value) {
                      setState(() {
                        sliderVal = value.toInt();
                      });
                      widget.ytController.seekTo(Duration(
                          seconds: ((value / 100) *
                                  widget
                                      .ytController.metadata.duration.inSeconds)
                              .toInt()));
                    },
                  ),
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
