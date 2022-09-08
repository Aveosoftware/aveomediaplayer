part of 'package:aveoplayer/aveoplayer.dart';

class iOSFaceBookVideoPlayer extends StatefulWidget {
  final String videoID;
  final bool showVideoTitle;
  final String? title;

  const iOSFaceBookVideoPlayer({
    Key? key,
    required this.videoID,
    this.showVideoTitle = false,
    this.title,
  }) : super(key: key);

  @override
  _iOSFaceBookVideoPlayerState createState() =>
      _iOSFaceBookVideoPlayerState(videoID, showVideoTitle, title);
}

class _iOSFaceBookVideoPlayerState extends State<iOSFaceBookVideoPlayer>
    with AutomaticKeepAliveClientMixin {
  final _key = UniqueKey();

  final String _videoID;
  final String? _title;
  final bool _showVideoTitle;

  _iOSFaceBookVideoPlayerState(
      this._videoID, this._showVideoTitle, this._title);

  int _stackToView = 1;

  void _handleLoad(String value) {
    setState(() {
      _stackToView = 0;
    });
  }

  final Completer<webview.WebViewController> _controller =
      Completer<webview.WebViewController>();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
//     String html = """
//     <!DOCTYPE html>
//           <html>
//             <head>
//         <meta charset="UTF-8">
//          <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
//           <meta http-equiv="X-UA-Compatible" content="ie=edge">
//            </head>
//           <body >                                 <video id="player" playsinline muted><source src="https://facebook-mp4-server.now.sh/video/redirect/${PlayerAppUIUtils.convertFacebookUrlToId(this._videoID)}" type="video/mp4" />
// </video><link rel="stylesheet" href="https://cdn.plyr.io/3.6.1/plyr.css" />
//           <script src="https://cdn.plyr.io/3.6.2/plyr.polyfilled.js"></script>
//           </script><script >var player = new Plyr('#player',{captions: {active: true}});</script>
//           </body>
//         </html>
//   """;
    String html = """
    
      <html>
<head>
  <title>Your Website Title</title>
</head>
<body>

  <!-- Load Facebook SDK for JavaScript -->
  <div id="fb-root"></div>
  <script async defer src="https://connect.facebook.net/en_US/sdk.js#xfbml=1&version=v3.2"></script>

  <!-- Your embedded video player code -->
  <div class="fb-video" data-href="https://www.facebook.com/${PlayerAppUIUtils.convertFacebookUrlToId(_videoID)}/" data-width="auto" data-height="250" data-show-text="false", data-allowfullscreen="false">
    <div class="fb-xfbml-parse-ignore">
      <blockquote cite="https://www.facebook.com/${PlayerAppUIUtils.convertFacebookUrlToId(_videoID)}/">
        <a href="https://www.facebook.com/${PlayerAppUIUtils.convertFacebookUrlToId(_videoID)}/">How to Share With Just Friends</a>
        <p>How to share with just friends.</p>
        Posted by <a href="https://www.facebook.com/facebook/">Facebook</a> on Friday, December 5, 2014
      </blockquote>
    </div>
  </div>

</body>
</html>
    
  """;
//
    String contentBase64 = base64Encode(const Utf8Encoder().convert(html));
    super.build(context);
    // Determine landscape or portrait
    Orientation currentOrientation = MediaQuery.of(context).orientation;

    return Card(
      child: IndexedStack(
        index: _stackToView,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                  height: currentOrientation == Orientation.portrait
                      ? 250
                      : MediaQuery.of(context).size.height * 1.2,
                  child: webview.WebView(
                    key: _key,
                    initialMediaPlaybackPolicy:
                        webview.AutoMediaPlaybackPolicy.always_allow,
                    initialUrl: 'data:text/html;base64,$contentBase64',
                    javascriptMode: webview.JavascriptMode.unrestricted,
                    debuggingEnabled: false,
                    onWebViewCreated:
                        (webview.WebViewController webViewController) {
                      _controller.complete(webViewController);
                    },
                    onPageStarted: (String url) {
                      log('Page started loading: $url');
                    },
                    onPageFinished: _handleLoad,
                    gestureNavigationEnabled: true,
                  )),
              _showVideoTitle == true
                  ? SizedBox(
                      child: Container(
                        margin: const EdgeInsets.only(
                          left: 10,
                          bottom: 15,
                          right: 10,
                        ),
                        child: Text(
                          _title ?? "",
                          style: const TextStyle(
                              fontSize: 20,
                              fontFamily: "Helvetica",
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    )
                  : const SizedBox.shrink()
            ],
          ),
          const CircularProgressIndicator(),
        ],
      ),
    );
  }
}
