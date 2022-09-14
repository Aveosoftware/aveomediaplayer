import 'dart:convert';

import 'package:aveoplayer/vid/video_player_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class AndroidFacebookPlayer extends StatefulWidget {
  final String videoID;
  final bool showVideoTitle;
  final String? title;

  const AndroidFacebookPlayer({
    Key? key,
    required this.videoID,
    this.showVideoTitle = false,
    this.title,
  }) : super(key: key);

  @override
  _AndroidFacebookPlayerState createState() =>
      _AndroidFacebookPlayerState(videoID, showVideoTitle, title);
}

class _AndroidFacebookPlayerState extends State<AndroidFacebookPlayer>
    with AutomaticKeepAliveClientMixin {
  final _key = UniqueKey();

  final String _videoID;
  final String? _title;
  final bool _showVideoTitle;

  _AndroidFacebookPlayerState(this._videoID, this._showVideoTitle, this._title);

  int _stackToView = 1;

  void _handleLoad(String value) {
    setState(() {
      _stackToView = 0;
    });
  }

  @override
  bool get wantKeepAlive => true;
  late InAppWebViewController webView;
  @override
  Widget build(BuildContext context) {
    // Determine landscape or portrait
    Orientation currentOrientation = MediaQuery.of(context).orientation;

//     String html = ''' <!DOCTYPE html><html lang="en">
//   <head><style type="text/css">body,html,%23chart{height: 100%;width: 100%;top:0;left:0;position:absolute;}div {-webkit-tap-highlight-color:rgba(255,255,255,0);}</style>           <meta name="viewport" content="width=device-width, initial-scale=1.0">
//       <meta charset="UTF-8">     </head><body>
//       <video id="player" playsinline controls >
//   <source src="https://facebook-mp4-server.now.sh/video/redirect/${PlayerAppUIUtils.convertFacebookUrlToId(this._videoID)}" type="video/mp4" />
// </video>
//       <link rel="stylesheet" href="https://cdn.plyr.io/3.6.1/plyr.css" /><script src="https://cdn.plyr.io/3.6.1/plyr.polyfilled.js"></script>
//       <script >var player = new Plyr('#player');</script>
//       </body></html>''';
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
  <div class="fb-video" data-href="https://www.facebook.com/${PlayerAppUIUtils.convertFacebookUrlToId(_videoID)}/" data-width="auto" data-height="250" data-show-text="false",  data-allowfullscreen="false">
    <div class="fb-xfbml-parse-ignore">
     <!-- <blockquote cite="https://www.facebook.com/${PlayerAppUIUtils.convertFacebookUrlToId(_videoID)}/">
        <a href="https://www.facebook.com/${PlayerAppUIUtils.convertFacebookUrlToId(_videoID)}/">How to Share With Just Friends</a>
        <p>How to share with just friends.</p>
        Posted by <a href="https://www.facebook.com/facebook/">Facebook</a> on Friday, December 5, 2014
      </blockquote>-->
    </div>
  </div>

</body>
</html>
    
  """;
//     String html = '''
//       <html>
// <head>
//   <title>Your Website Title</title>
// </head>
// <body>

//   <!-- Load Facebook SDK for JavaScript -->
//   <div id="fb-root"></div>
//   <script async defer src="https://connect.facebook.net/en_US/sdk.js#xfbml=1&version=v3.2"></script>

//   <!-- Your embedded video player code -->
//   <div class="fb-video" data-href="https://www.facebook.com/${PlayerAppUIUtils.convertFacebookUrlToId(this._videoID)}/" data-width="auto" data-height="auto" data-show-text="false", data-allowfullscreen="false">
//     <div class="fb-xfbml-parse-ignore col-md-12 col-xs-12">
//       <iframe
//     src="https://www.facebook.com/${PlayerAppUIUtils.convertFacebookUrlToId(this._videoID)}/"
//     allowfullscreen
//     allowtransparency
//     allow="autoplay"
//   ></iframe>
//     </div>
//   </div>

// </body>
// </html>
//       ''';

    String contentBase64 = base64Encode(const Utf8Encoder().convert(html));
    super.build(context);
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
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
                  child: InAppWebView(
                    initialData: InAppWebViewInitialData(
                      data: 'data:text/html;base64,$contentBase64',
                    ),
                    key: _key,
                    initialOptions: InAppWebViewGroupOptions(
                        android: AndroidInAppWebViewOptions(
                          displayZoomControls: false,
                          supportMultipleWindows: false,
                          loadWithOverviewMode: true,
                          allowContentAccess: true,
                          disabledActionModeMenuItems:
                              AndroidActionModeMenuItem.MENU_ITEM_NONE,
                          useWideViewPort: true,
                        ),
                        crossPlatform: InAppWebViewOptions(
                            javaScriptEnabled: true,
                            javaScriptCanOpenWindowsAutomatically: true,
                            mediaPlaybackRequiresUserGesture: false,
//                        initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
                            horizontalScrollBarEnabled: false,
                            transparentBackground: true,
                            preferredContentMode:
                                UserPreferredContentMode.DESKTOP)),
                    onWebViewCreated: (InAppWebViewController controller) {
                      webView = controller;
                    },
                    onLoadStop: (controller, url) {
                      _handleLoad(url.toString());
                    },
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
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
