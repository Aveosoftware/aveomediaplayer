import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:aveoplayer/vid/video_player_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:webview_flutter/webview_flutter.dart' as webview;

//iOS Vimeo player
class IOSVimeoWidget extends StatefulWidget {
  final String videoID;
  final bool showVideoTitle;
  final String? title;

  const IOSVimeoWidget({
    Key? key,
    required this.videoID,
    this.showVideoTitle = false,
    this.title,
  }) : super(key: key);

  @override
  _IOSVimeoWidgetState createState() =>
      _IOSVimeoWidgetState(videoID, showVideoTitle, title);
}

class _IOSVimeoWidgetState extends State<IOSVimeoWidget>
    with AutomaticKeepAliveClientMixin {
  final _key = UniqueKey();

  final Completer<webview.WebViewController> _controller =
      Completer<webview.WebViewController>();

  final String _videoID;
  final String? _title;
  final bool _showVideoTitle;

  _IOSVimeoWidgetState(this._videoID, this._showVideoTitle, this._title);

  int _stackToView = 1;

  void _handleLoad(String value) {
    setState(() {
      _stackToView = 0;
    });
  }

  late InAppWebViewController webView;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    // Determine landscape or portrait
    Orientation currentOrientation = MediaQuery.of(context).orientation;

    String html = '''
        <!DOCTYPE html><html lang="en"><head><style type="text/css">body,html,%23chart{height: 100%;width: 100%;margin: 0px;}div {-webkit-tap-highlight-color:rgba(255,255,255,0);}</style>  
        <meta name="viewport" content="width=device-width, initial-scale=1.0"> 
        <meta charset="UTF-8">
        </head>
        <body>

        <div class="plyr__video-embed" id="player">
        <iframe src="https://player.vimeo.com/video/${PlayerAppUIUtils.convertVimeoUrlToId(_videoID)}?loop=false&amp;byline=false&amp;portrait=false&amp;title=false&amp;speed=true&amp;transparent=0&amp;gesture=media;fullscreen" width="640" height="360"
        frameborder="0" allow="autoplay; fullscreen" ></iframe> </p>
        </div>
      <link rel="stylesheet" href="https://cdn.plyr.io/3.6.1/plyr.css" />
      <script src="https://cdn.plyr.io/3.6.1/plyr.polyfilled.js">
      </script><script >var player = new Plyr('#player',{captions: {active: true}});</script>
      </body>
      </html>
      ''';
//     String html = '''
//   <iframe src="https://player.vimeo.com/video/${PlayerAppUIUtils.convertVimeoUrlToId(_videoID)}?loop=false&amp;byline=false&amp;portrait=false&amp;title=false&amp;speed=true&amp;transparent=0&amp;gesture=media" width="100%" height="100%"
//  frameborder="-1" allow="autoplay; fullscreen" allowfullscreen></iframe>
//       ''';
    // src="https://player.vimeo.com/video/${PlayerAppUIUtils.convertVimeoUrlToId(_videoID)}?loop=false&amp;byline=false&amp;portrait=false&amp;title=false&amp;speed=true&amp;transparent=0&amp;gesture=media"

    String contentBase64 = base64Encode(const Utf8Encoder().convert(html));
    super.build(context);
    return Card(
      child: IndexedStack(
        index: _stackToView,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(
                // height:
                //     MediaQuery.of(context).size.height * 0.2,
                child: webview.WebView(
                  initialMediaPlaybackPolicy:
                      webview.AutoMediaPlaybackPolicy.always_allow,
                  key: _key,
                  debuggingEnabled: false,

                  zoomEnabled: true,
                  initialUrl:
                      "https://player.vimeo.com/video/${PlayerAppUIUtils.convertVimeoUrlToId(_videoID)}?loop=false&amp;byline=false&amp;portrait=false&amp;title=false&amp;speed=true&amp;transparent=0&amp;gesture=media",

                  // initialUrl: _videoID,
                  javascriptMode: webview.JavascriptMode.unrestricted,
                  onWebViewCreated:
                      (webview.WebViewController webViewController) {
                    _controller.complete(webViewController);
                  },
                  onPageStarted: (String url) {
                    log('Page started loading: $url');
                  },
                  onPageFinished: _handleLoad,
                  gestureNavigationEnabled: true,
                ),
              ),
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
          const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
