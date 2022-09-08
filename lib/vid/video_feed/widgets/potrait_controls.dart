part of 'package:aveoplayer/aveoplayer.dart';

class FeedPlayerPortraitControls extends StatelessWidget {
  const FeedPlayerPortraitControls(
      {Key? key, this.flickMultiManager, this.flickManager})
      : super(key: key);

  final FlickMultiManager? flickMultiManager;
  final FlickManager? flickManager;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          FlickAutoHideChild(
            showIfVideoNotInitialized: false,
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: FlickLeftDuration(),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                flickManager?.flickControlManager?.toggleFullscreen();
              },
            ),
            // child: FlickToggleSoundAction(
            //   toggleMute: () {
            //     flickMultiManager?.toggleMute();
            //     displayManager.handleShowPlayerControls();
            //   },
            //   // child: FlickSeekVideoAction(
            //   //   child: Center(child: FlickVideoBuffer()
            //   //   ),
            //   // ),
            // ),
          ),
          FlickAutoHideChild(
            autoHide: false,
            showIfVideoNotInitialized: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                //FlickFullScreenToggle(),
                Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(96, 10, 9, 9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: FlickSoundToggle(
                    toggleMute: () => flickMultiManager?.toggleMute(),
                    color: Colors.white,
                  ),
                ),
                //FlickFullScreenToggle(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
