part of 'package:aveoplayer/aveoplayer.dart';

//iOS YouTube Player
class IOSYouTubeWidget extends StatefulWidget {
  final String videoID;
  final bool showVideoTitle;
  final String? title;

  const IOSYouTubeWidget({
    Key? key,
    required this.videoID,
    this.showVideoTitle = false,
    this.title,
  }) : super(key: key);

  @override
  _IOSYouTubeWidgetState createState() =>
      _IOSYouTubeWidgetState(videoID, showVideoTitle, title);
}

class _IOSYouTubeWidgetState extends State<IOSYouTubeWidget>
    with AutomaticKeepAliveClientMixin {
  final _key = UniqueKey();

  final String _videoID;
  final String? _title;
  final bool _showVideoTitle;

  _IOSYouTubeWidgetState(this._videoID, this._showVideoTitle, this._title);

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
    String html = """
    <!DOCTYPE html>
          <html>
            <head>
        <meta charset="UTF-8">
         <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
          <meta http-equiv="X-UA-Compatible" content="ie=edge">
           </head>
          <body >                                    
        <div class="plyr__video-embed" id="player">
         <iframe
          id="vjs_video_3_Youtube_api"
          style="width:100%;height:100%;top:0;left:0;position:absolute;"
          class="vjs-tech holds-the-iframe"
          frameborder="0"
          allowfullscreen="1"
          allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture"
          webkitallowfullscreen mozallowfullscreen allowfullscreen
          title="Live Tv"
          frameborder="0"
          src="https://www.youtube.com/embed/${PlayerAppUIUtils.convertYouTubeUrlToId(_videoID)}"
          ></iframe></div>
          <link rel="stylesheet" href="https://cdn.plyr.io/3.6.1/plyr.css" />
          <script src="https://cdn.plyr.io/3.6.2/plyr.polyfilled.js"></script>
          </script><script >var player = new Plyr('#player',{captions: {active: true}});</script>
          </body>                                    
        </html>
  """;
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
                    initialUrl: Uri.tryParse(
                            "https://www.youtube.com/embed/${PlayerAppUIUtils.convertYouTubeUrlToId(_videoID)}")
                        .toString(),
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
