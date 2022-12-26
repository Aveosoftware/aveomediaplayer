part of 'package:aveoplayer/aveoplayer.dart';

class DefaultBottomControls extends StatefulWidget {
  final VideoPlayerController controller;
  const DefaultBottomControls({Key? key, required this.controller})
      : super(key: key);

  @override
  State<DefaultBottomControls> createState() => _DefaultBottomControlsState();
}

class _DefaultBottomControlsState extends State<DefaultBottomControls> {
  late Timer sliderRefresh;
  sliderValSetter() {
    sliderRefresh = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (widget.controller.value.isPlaying && mounted) {
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  onPressed: () => showModalBottomSheet(
                      context: context,
                      builder: (_) => PlaybackSpeedVimeo(
                            controller: widget.controller,
                          ),
                      backgroundColor: Colors.white),
                  icon: const Icon(
                    Icons.speed,
                    color: Colors.white,
                  )),
              IconButton(
                  onPressed: () => widget.controller.seekTo(Duration(
                      seconds:
                          widget.controller.value.position.inSeconds - 10)),
                  icon: const Icon(Icons.replay_10, color: Colors.white)),
              IconButton(
                  onPressed: () {
                    widget.controller.value.isPlaying
                        ? widget.controller.pause()
                        : widget.controller.play();
                    setState(() {});
                  },
                  icon: widget.controller.value.isPlaying
                      ? const Icon(Icons.pause, color: Colors.white)
                      : const Icon(Icons.play_arrow, color: Colors.white)),
              IconButton(
                  onPressed: () => widget.controller.seekTo(Duration(
                      seconds:
                          widget.controller.value.position.inSeconds + 10)),
                  icon: const Icon(Icons.forward_10, color: Colors.white)),
              IconButton(
                  onPressed: () => widget.controller.toggleFullScreen(context),
                  icon: widget.controller.isFullScreen.value
                      ? const Icon(
                          Icons.fullscreen_exit,
                          color: Colors.white,
                        )
                      : const Icon(Icons.fullscreen, color: Colors.white)),
            ]),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(
              width: 10,
            ),
            Expanded(
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
                onSeek: (value) => widget.controller.seekTo(value),
                total: widget.controller.value.duration,
                progress: widget.controller.value.position,
                buffered: Duration(
                    seconds: widget.controller.value.buffered.fold(
                        0,
                        (previousValue, element) =>
                            previousValue +
                            (element.end.inSeconds - element.start.inSeconds))),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
        const SizedBox(
          height: 18,
        ),
      ],
    );
  }
}
