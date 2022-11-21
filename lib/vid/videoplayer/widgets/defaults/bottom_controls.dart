part of 'package:aveoplayer/aveoplayer.dart';

class DefaultBottomControls extends StatefulWidget {
  final VideoPlayerController controller;
  const DefaultBottomControls({Key? key, required this.controller})
      : super(key: key);

  @override
  State<DefaultBottomControls> createState() => _DefaultBottomControlsState();
}

class _DefaultBottomControlsState extends State<DefaultBottomControls> {
  double sliderVal = 0.0;

  sliderValSetter() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (widget.controller.value.isPlaying && mounted) {
        setState(() {
          if (widget.controller.value.position.inSeconds == 0 &&
              widget.controller.value.duration.inSeconds == 0) {
            sliderVal = 0;
          } else {
            sliderVal = ((widget.controller.value.position.inSeconds /
                    widget.controller.value.duration.inSeconds) *
                100);
          }
        });
      }
    });
  }

  @override
  void didUpdateWidget(DefaultBottomControls oldWidget) {
    if (oldWidget.controller != widget.controller) {
      setState(() {
        sliderVal = 0.0;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    sliderValSetter();
    super.initState();
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
                  icon: widget.controller.isFullScreen().value
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
            Text(
              printDuration(widget.controller.value.position),
              style: progressStyle,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
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
                      sliderVal = value;
                    });
                    widget.controller.seekTo(Duration(
                        seconds: ((value / 100) *
                                widget.controller.value.duration.inSeconds)
                            .toInt()));
                  },
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              printDuration(widget.controller.value.duration),
              style: progressStyle,
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
