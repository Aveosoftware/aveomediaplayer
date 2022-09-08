part of 'package:aveoplayer/aveoplayer.dart';

class VideoPlayerControls extends StatefulWidget {
  final VideoPlayerController vpController;
  const VideoPlayerControls({Key? key, required this.vpController})
      : super(key: key);

  @override
  State<VideoPlayerControls> createState() => _VideoPlayerControlsState();
}

class _VideoPlayerControlsState extends State<VideoPlayerControls> {
  int sliderVal = 0;
  bool visibleControls = true;
  bool fullScreen = false;

  sliderValSetter() async {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      if ((widget.vpController.value.isPlaying) && mounted) {
        setState(() {
          sliderVal = ((widget.vpController.value.position.inSeconds /
                      widget.vpController.value.duration.inSeconds) *
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

  playVid() {
    widget.vpController.play();
    Future.delayed(const Duration(seconds: 2), () {
      // widget.playerVisibility(false);
      setState(() {
        visibleControls = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: GestureDetector(
        onTap: () {
          if (mounted) {
            setState(() {
              visibleControls = true;
            });
          }
          Future.delayed(const Duration(seconds: 2), () {
            // widget.playerVisibility(false);
            if (mounted) {
              setState(() {
                visibleControls = false;
              });
            }
          });
        },
        child: Visibility(
          replacement: Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  color: Colors.transparent,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Container(
                  height: 2,
                  color: Color(0xffe9e9e9),
                  width: MediaQuery.of(context).size.width * sliderVal / 100,
                ),
              )
            ],
          ),
          visible: visibleControls,
          child: AnimatedOpacity(
            duration: const Duration(seconds: 1),
            opacity: visibleControls ? 1 : 0,
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: Color(0x4c0A0A0A),
                  child: Center(
                    child: GestureDetector(
                      onTap: () => widget.vpController.value.isPlaying
                          ? widget.vpController.pause()
                          : playVid(),
                      child: widget.vpController.value.isPlaying
                          ? const Icon(
                              Icons.pause,
                              color: Colors.white,
                              size: 40,
                            )
                          : const Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 40,
                            ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: SizedBox(
                    height: 96,
                    child: Container(
                      height: 20,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.5),
                            Colors.black
                          ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter)),
                      child: Column(children: [
                        const SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              // IconButton(
                              //     onPressed: playerController.videoNo.value == 0
                              //         ? null
                              //         : () {
                              //             // print(
                              //             //     'video value: ${playerController.videoNo.value}');
                              //             if (playerController.videoNo.value !=
                              //                 0) {
                              //               playerController.videoNo.value--;
                              //               playerController.queue();
                              //             }
                              //           },
                              //     icon: Icon(
                              //       Icons.skip_previous,
                              //       size: 30,
                              //       color: playerController.videoNo.value == 0
                              //           ? Colors.grey
                              //           : Colors.white,
                              //     )),
                              IconButton(
                                onPressed: () {
                                  widget.vpController.toggleFullScreen(context);
                                },
                                icon: fullScreen
                                    ? const Icon(
                                        Icons.fullscreen_exit,
                                        color: Colors.white,
                                      )
                                    : const Icon(
                                        Icons.fullscreen,
                                        color: Colors.white,
                                      ),
                              ),
                              // IconButton(
                              //     onPressed: playerController.videoNo.value ==
                              //             playerController.videos.length - 1
                              //         ? null
                              //         : () {
                              //             // print(
                              //             //     'video value: ${playerController.videoNo.value}');
                              //             if (playerController.videoNo.value <
                              //                 playerController.videos.length -
                              //                     1) {
                              //               // widget.vpController.seekTo(Duration(
                              //               //     seconds: widget.vpController.value
                              //               //         .duration.inSeconds));
                              //               playerController.videoNo.value++;
                              //               playerController.queue();
                              //             }
                              //           },
                              //     icon: Icon(
                              //       Icons.skip_next,
                              //       size: 30,
                              //       color: playerController.videoNo.value ==
                              //               playerController.videos.length - 1
                              //           ? Colors.grey
                              //           : Colors.white,
                              //     )),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: [
                              Text(
                                '${printDuration(widget.vpController.value.position)}/${printDuration(widget.vpController.value.duration)}',
                                style: progressStyle,
                              ),
                              const Spacer(
                                flex: 1,
                              ),
                              GestureDetector(
                                onTap: () => showModalBottomSheet(
                                    context: context,
                                    builder: (_) => PlaybackSpeedVimeo(
                                          controller: widget.vpController,
                                        ),
                                    backgroundColor: Colors.white),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
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
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: SliderTheme(
                            data: SliderThemeData(
                                thumbColor: Color(0xffe9e9e9),
                                activeTrackColor: Color(0xffe9e9e9),
                                inactiveTrackColor: Color(0xff3E3D3D),
                                trackShape: CustomTrackShape(),
                                overlayShape: SliderComponentShape.noThumb,
                                thumbShape: const RoundSliderThumbShape(
                                    pressedElevation: 0, enabledThumbRadius: 5),
                                trackHeight: 2),
                            child: Slider(
                              min: 0,
                              max: 100,
                              value: sliderVal.toDouble(),
                              onChanged: (double value) {
                                if (mounted) {
                                  setState(() {
                                    sliderVal = value.toInt();
                                  });
                                }
                                widget.vpController.seekTo(Duration(
                                    seconds: ((value / 100) *
                                            (widget.vpController.value.duration
                                                .inSeconds))
                                        .toInt()));
                              },
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

typedef BoolCallBack = void Function(bool fullscreen);

TextStyle progressStyle = const TextStyle(
  fontSize: 9,
  fontWeight: FontWeight.w600,
  // height: 16,
  fontStyle: FontStyle.normal,
  color: Colors.white,
);

class VimeoVideoPlayer extends StatefulWidget {
  final String videoID;
  final String accessKey;
  final String eventId;

  const VimeoVideoPlayer(
      {Key? key, required this.videoID, this.accessKey = '', this.eventId = ''})
      : super(key: key);

  @override
  State<VimeoVideoPlayer> createState() => _VimeoVideoPlayerState();
}

class _VimeoVideoPlayerState extends State<VimeoVideoPlayer> {
  bool fullscreen = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: initVimeo(
          id: widget.videoID,
          accessKey: widget.accessKey,
          eventId: widget.eventId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade700)),
              child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                      color: Colors.black,
                      child: const Center(
                          child: CircularProgressIndicator(
                        color: Color(0x99ffffff),
                      )))));
        }
        if (snapshot.data is VimeoError) {
          return Container(
            decoration:
                BoxDecoration(border: Border.all(color: Colors.grey.shade700)),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    '${(snapshot.data as VimeoError).developerMessage}'
                    '\n${(snapshot.data as VimeoError).errorCode ?? ''}'
                    '\n\n${(snapshot.data as VimeoError).error}',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          );
        }
        if (snapshot.data is VideoPlayerController) {
          VideoPlayerController vPController = snapshot.data;
          return AspectRatio(
            // aspectRatio: controller
            //     .vPController.value.value.aspectRatio,
            aspectRatio: fullscreen
                ? MediaQuery.of(context).size.width /
                    MediaQuery.of(context).size.height
                : 16 / 9,
            child: !vPController.value.isInitialized
                ? Container(
                    color: Colors.black,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        AspectRatio(
                          aspectRatio: (vPController.value.aspectRatio),
                          child: VideoPlayer(vPController),
                        ),
                        VideoPlayerControls(
                          vpController: vPController,
                        ),
                      ],
                    ),
                  )
                : vPController.value.isPlaying
                    ? Container(
                        color: Colors.black,
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            AspectRatio(
                              aspectRatio: (vPController.value.aspectRatio),
                              child: VideoPlayer(vPController),
                            ),
                            VideoPlayerControls(
                              vpController: vPController,
                            ),
                          ],
                        ),
                      )
                    : Container(
                        color: Colors.black,
                        child: const Center(
                            child: CircularProgressIndicator(
                          color: Color(0x99ffffff),
                        )),
                      ),
          );
        }

        return Container(
            decoration:
                BoxDecoration(border: Border.all(color: Colors.grey.shade700)),
            child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                    color: Colors.black,
                    child: const Center(
                        child: CircularProgressIndicator(
                      color: Color(0x99ffffff),
                    )))));
      },
    );
  }
}
