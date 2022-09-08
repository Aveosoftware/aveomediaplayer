part of 'package:aveoplayer/aveoplayer.dart';

class NativeCustomYT {
  static YoutubePlayerController createYTController(
      {required String videoID, YTFlags flags = const YTFlags()}) {
    return YoutubePlayerController(initialVideoId: videoID, flags: flags);
  }
}

class YTFlags extends YoutubePlayerFlags {
  @override
  final bool hideControls;
  @override
  final bool controlsVisibleAtStart;
  @override
  final bool autoPlay;
  @override
  final bool mute;
  @override
  final bool isLive;
  @override
  final bool hideThumbnail;
  @override
  final bool disableDragSeek;
  @override
  final bool enableCaption;
  @override
  final String captionLanguage;
  @override
  final bool loop;
  @override
  final bool forceHD;
  @override
  final int startAt;
  @override
  final int? endAt;
  @override
  final bool useHybridComposition;
  @override
  final bool showLiveFullscreenButton;

  const YTFlags({
    this.hideControls = false,
    this.controlsVisibleAtStart = false,
    this.autoPlay = true,
    this.mute = false,
    this.isLive = false,
    this.hideThumbnail = false,
    this.disableDragSeek = false,
    this.enableCaption = true,
    this.captionLanguage = 'en',
    this.loop = false,
    this.forceHD = false,
    this.startAt = 0,
    this.endAt,
    this.useHybridComposition = true,
    this.showLiveFullscreenButton = true,
  });
}
