part of 'package:aveoplayer/aveoplayer.dart';

//Android YouTube player
class AndroidYoutubeWidget extends StatefulWidget {
  final String videoID;
  final bool showVideoTitle;
  final String? title;

  const AndroidYoutubeWidget({
    Key? key,
    required this.videoID,
    this.showVideoTitle = false,
    this.title,
  }) : super(key: key);

  @override
  _AndroidYoutubeWidgetState createState() =>
      _AndroidYoutubeWidgetState(videoID, showVideoTitle, title);
}

class _AndroidYoutubeWidgetState extends State<AndroidYoutubeWidget>
    with AutomaticKeepAliveClientMixin {
  final _key = UniqueKey();

  final String _videoID;
  final String? _title;
  final bool _showVideoTitle;

  _AndroidYoutubeWidgetState(this._videoID, this._showVideoTitle, this._title);

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
      <!DOCTYPE html><html lang="en">
      <head>
      <style type="text/css">body,html,%23chart{height: 100%;width: 100%;top:0;left:0;position:absolute;}div {-webkit-tap-highlight-color:rgba(255,255,255,0);}</style>
      <meta name="viewport" content="width=device-width, initial-scale=1.0">     
      <meta charset="UTF-8"> 
      </head>
      <body>
      <div id="player" data-plyr-provider="youtube" data-plyr-embed-id="${PlayerAppUIUtils.convertYouTubeUrlToId(_videoID)}"></div>
      <link rel="stylesheet" href="https://cdn.plyr.io/3.6.1/plyr.css" />
      <script src="https://cdn.plyr.io/3.6.1/plyr.polyfilled.js"></script>
      <script >var player = new Plyr('#player');</script>
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
              Expanded(
                // height: currentOrientation == Orientation.portrait
                //     ? 250
                //     : MediaQuery.of(context).size.height * 1.2,
                child: InAppWebView(
                  // initialData: InAppWebViewInitialData(
                  //   data: 'data:text/html;base64,$contentBase64',
                  // ),
                  initialUrlRequest: URLRequest(
                    url: Uri.tryParse(
                        "https://www.youtube.com/embed/${PlayerAppUIUtils.convertYouTubeUrlToId(_videoID)}"),
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
                        //initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
                        horizontalScrollBarEnabled: false,
                        transparentBackground: true,
                        preferredContentMode: UserPreferredContentMode.DESKTOP,
                      )),
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
