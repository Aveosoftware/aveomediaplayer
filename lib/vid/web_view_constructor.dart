part of 'package:aveoplayer/aveoplayer.dart';

class AveoEmbededPlayer extends StatelessWidget {
  final EmbededPlayerType type;
  final bool showVideoTitle;
  final String videoID;
  final String? title;

  const AveoEmbededPlayer(
      {super.key,
      required this.type,
      required this.videoID,
      this.showVideoTitle = false,
      this.title});

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case EmbededPlayerType.youTube:
        return Platform.isAndroid
            ? AndroidYoutubeWidget(
                videoID: videoID,
                showVideoTitle: showVideoTitle,
                title: title,
              )
            : IOSYouTubeWidget(
                videoID: videoID,
                showVideoTitle: showVideoTitle,
                title: title,
              );
      case EmbededPlayerType.vimeo:
        return Platform.isAndroid
            ? AndroidVimeoWidget(
                videoID: videoID,
                showVideoTitle: showVideoTitle,
                title: title,
              )
            : IOSVimeoWidget(
                videoID: videoID,
                showVideoTitle: showVideoTitle,
                title: title,
              );
      default:
        return Container(
          color: Colors.black,
          height: 200,
          width: MediaQuery.of(context).size.width,
          child: const Center(
            child: Text('No Such widget available'),
          ),
        );
    }
  }
}

enum EmbededPlayerType {
  youTube,
  vimeo,
}
