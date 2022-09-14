part of 'package:aveoplayer/aveoplayer.dart';

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
