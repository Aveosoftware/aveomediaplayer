part of 'package:aveoplayer/aveoplayer.dart';

class PlayerItems extends StatefulWidget {
  const PlayerItems(
      {Key? key, required this.url, required this.flickMultiManager})
      : super(key: key);
  final String url;
  final FlickMultiManager flickMultiManager;

  @override
  _PlayerItemsState createState() => _PlayerItemsState();
}

class _PlayerItemsState extends State<PlayerItems> {
  @override
  late FlickManager flickManager;

  @override
  void initState() {
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network(widget.url)
        ..setLooping(true),
      autoPlay: false,
    );

    widget.flickMultiManager.init(flickManager);

    super.initState();
  }

  @override
  void dispose() {
    widget.flickMultiManager.remove(flickManager);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ObjectKey(flickManager),
      onVisibilityChanged: (visiblityInfo) {
        if (visiblityInfo.visibleFraction > 0.9) {
          widget.flickMultiManager.play(flickManager);
        }
      },
      child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * .6,
          child: VideoPlayerUI(flickManager: flickManager, widget: widget)),
    );
  }
}

class VideoPlayerUI extends StatelessWidget {
  const VideoPlayerUI({
    Key? key,
    required this.flickManager,
    required this.widget,
  }) : super(key: key);

  final FlickManager flickManager;
  final PlayerItems widget;

  @override
  Widget build(BuildContext context) {
    return FlickVideoPlayer(
      preferredDeviceOrientationFullscreen: ((flickManager.flickVideoManager
                      ?.videoPlayerController?.value.aspectRatio ??
                  1.0) >
              1.0)
          ? [DeviceOrientation.landscapeLeft]
          : [DeviceOrientation.portraitUp],
      flickManager: flickManager,
      flickVideoWithControls: FlickVideoWithControls(
        videoFit: BoxFit.fill,
        playerLoadingFallback: Positioned.fill(
          child: Stack(
            children: <Widget>[
              // Positioned.fill(
              //   child: Image.asset(
              //     widget.image!,
              //     fit: BoxFit.cover,
              //   ),
              // ),
              const Positioned(
                right: 10,
                top: 10,
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    strokeWidth: 4,
                  ),
                ),
              ),
            ],
          ),
        ),
        controls: FeedPlayerPortraitControls(
          flickMultiManager: widget.flickMultiManager,
          flickManager: flickManager,
        ),
      ),
      flickVideoWithControlsFullscreen: const FlickVideoWithControls(
        videoFit: BoxFit.fitWidth,
        playerLoadingFallback: Center(
            //     child: Image.network(
            //   widget.image!,
            //   fit: BoxFit.fitWidth,
            // )
            ),
        controls: FlickLandscapeControls(),
        iconThemeData: IconThemeData(
          size: 40,
          color: Colors.white,
        ),
        textStyle: TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }
}
