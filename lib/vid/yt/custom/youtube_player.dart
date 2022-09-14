part of 'package:aveoplayer/aveoplayer.dart';

class AveoYouTubePlayer extends StatefulWidget {
  final Key? playerKey;
  final YoutubePlayerController youtubePlayerController;
  final Widget Function(BuildContext context, Widget player) builder;
  final double? width;
  final double aspectRatio;
  final Duration controlsTimeOut;
  final Widget? bufferIndicator;
  final ProgressBarColors progressColors;
  final Color progressIndicatorColor;
  final VoidCallback? onReady;
  final void Function(YoutubeMetaData metaData)? onEnded;
  final Color liveUIColor;
  final List<Widget>? topActions;
  final List<Widget>? bottomActions;
  final EdgeInsetsGeometry actionsPadding;
  final Widget? thumbnail;
  final bool showVideoProgressIndicator;
  final void Function()? onEnterFullScreen;
  final void Function()? onExitFullScreen;
  const AveoYouTubePlayer({
    Key? key,
    required this.youtubePlayerController,
    required this.builder,
    this.playerKey,
    this.width,
    this.aspectRatio = 16 / 9,
    this.controlsTimeOut = const Duration(seconds: 3),
    this.bufferIndicator,
    this.progressIndicatorColor = Colors.red,
    this.progressColors = const ProgressBarColors(),
    this.onReady,
    this.onEnded,
    this.liveUIColor = Colors.red,
    this.topActions,
    this.bottomActions,
    this.actionsPadding = const EdgeInsets.all(8.0),
    this.thumbnail,
    this.showVideoProgressIndicator = false,
    this.onEnterFullScreen,
    this.onExitFullScreen,
  }) : super(key: key);

  @override
  State<AveoYouTubePlayer> createState() => _AveoYouTubePlayerState();
}

class _AveoYouTubePlayerState extends State<AveoYouTubePlayer> {
  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        key: widget.playerKey,
        controller: widget.youtubePlayerController,
        topActions: widget.topActions,
        bottomActions: widget.bottomActions,
        bufferIndicator: widget.bufferIndicator,
        showVideoProgressIndicator: widget.showVideoProgressIndicator,
        progressColors: widget.progressColors,
        liveUIColor: widget.liveUIColor,
        actionsPadding: widget.actionsPadding,
        aspectRatio: widget.aspectRatio,
        controlsTimeOut: widget.controlsTimeOut,
        onEnded: widget.onEnded,
        onReady: widget.onReady,
        progressIndicatorColor: widget.progressIndicatorColor,
        thumbnail: widget.thumbnail,
        width: widget.width,
      ),
      builder: widget.builder,
      onEnterFullScreen: widget.onEnterFullScreen,
      onExitFullScreen: widget.onExitFullScreen,
    );
  }
}
