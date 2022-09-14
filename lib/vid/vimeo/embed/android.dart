import 'dart:convert';

import 'package:aveoplayer/vid/video_player_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

//Android Vimeo player
class AndroidVimeoWidget extends StatefulWidget {
  final String videoID;
  final bool showVideoTitle;
  final String? title;

  const AndroidVimeoWidget({
    Key? key,
    required this.videoID,
    this.showVideoTitle = false,
    this.title,
  }) : super(key: key);

  @override
  _AndroidVimeoWidgetState createState() =>
      _AndroidVimeoWidgetState(videoID, showVideoTitle, title);
}

class _AndroidVimeoWidgetState extends State<AndroidVimeoWidget>
    with AutomaticKeepAliveClientMixin {
  final _key = UniqueKey();

  final String _videoID;
  final String? _title;
  final bool _showVideoTitle;

  _AndroidVimeoWidgetState(this._videoID, this._showVideoTitle, this._title);

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
    <!DOCTYPE html>
    <html lang="en">
    <head>
    <style type="text/css">body,html,%23chart{height: 100%;width: 100%;margin: 0px;}div {-webkit-tap-highlight-color:rgba(255,255,255,0);}</style>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"> 
    <meta charset="UTF-8">
    </head>
    <body>

    <div class="plyr__video-embed" id="player">
    <iframe 
      src="https://player.vimeo.com/video/${PlayerAppUIUtils.convertVimeoUrlToId(_videoID)}?loop=false&amp;byline=false&amp;portrait=false&amp;title=false&amp;speed=true&amp;transparent=0&amp;gesture=media"
      allowfullscreen
      allowtransparency
      allow="autoplay"
    ></iframe>
    </div>
    <link rel="stylesheet" href="https://cdn.plyr.io/3.6.1/plyr.css" />
    <script src="https://cdn.plyr.io/3.6.1/plyr.polyfilled.js">
    </script>
    <script >var player = new Plyr('#player',{captions: {active: true}});</script>
    </body>
    </html>
      
      ''';

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
                // height: currentOrientation == Orientation.portrait
                //     ? 250
                //     : MediaQuery.of(context).size.height * 1.2,
                child: InAppWebView(
                  // initialData: InAppWebViewInitialData(
                  //   data: contentBase64,
                  // ),
                  initialUrlRequest: URLRequest(
                    url: Uri.tryParse(
                        "https://player.vimeo.com/video/${PlayerAppUIUtils.convertVimeoUrlToId(_videoID)}?loop=false&amp;byline=false&amp;portrait=false&amp;title=false&amp;speed=true&amp;transparent=0&amp;gesture=media"),
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
    );
  }
}
