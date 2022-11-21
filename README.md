# Aveoplayer

Aveoplayer is working towards adding Video playback support as easy as possible for developers

## Features

1. [Youtube Video player](#youtube)
   1. [Embeded web View](#youtube-embeded-web-view)
   2. [Custom page view](#youtube-custom-page-view)
2. [Vimeo video player](#vimeo-video-player)
   1. [Embeded web view](#vimeo-embeded-web-view)
   2. [Media url fetching from server utility](#use-vimeo-video-player-utiliteis)
3. [Custom Video player page view](#custom-video-player)
   1. Default (using pre-fetched video player controller)
   2. [Network](#custom-video-player)
   3. File
   4. Assets
   5. Content URI
4. [Social media like video players page](#social-media-like-page) 
   
## Usage

### YouTube

#### YouTube Embeded Web View

```dart
AveoEmbededPlayer(
                  type: EmbededPlayerType.youTube,
                  videoID: 'https://www.youtube.com/watch?v=5FNCukepaS8' //Your video URL
                  )
```

#### YouTube Custom page View

```dart
AveoYouTubePlayer(
        youtubePlayerController: YoutubePlayerController(
          initialVideoId: '5FNCukepaS8', //Your video ID
          flags: const YoutubePlayerFlags(
            autoPlay: true,
          ),
        ),
        builder: (context, player) {
          return Scaffold(
            appBar: AppBar(
              title: Text('This is Home'),
              centerTitle: true,
            ),
            body: Column(
              children: [
                //This is your video player widget
                player,
                Expanded(
                    child: Column(
                  children: [
                    Text('Body data'),
                  ],
                ))
              ],
            ),
          );
        })
```

### Vimeo Video player

#### Vimeo Embeded web view

```dart
AveoEmbededPlayer(
                  type: EmbededPlayerType.vimeo,
                  videoID: 'https://vimeo.com/347119375' //Your video URL
                  )
```

#### Use Vimeo video player Utiliteis

After calling the following example method you can forward the URL to [```AveoVideoPlayer.network()```](#custom-video-player)

```dart
Future<String> loadVimeoUrl({String vimeoId}) async {
    try{
    VimeoVideo vimeoViedo = await Vimeo(videoId: '347119375'/*your video Id*/).load;
    return vimeoViedo.videoUrl;
    }
    catch(e){
        return 'failed to load Url'
    }
}
```

### Custom Video Player

```dart
AveoVideoPlayer.network(
    //Your video URL
      uri:
          'https://assets.mixkit.co/videos/preview/mixkit-exercising-by-climbing-the-steps-of-some-bleachers-40758-large.mp4',
      autoplay: true,
      onComplete: () => log('video ended'),
      builder: (context, player, playerController) {
        return SafeArea(
          child: Scaffold(
            body: Column(
              children: [
                //This is your video player widget
                player,
                Card(
                  elevation: 5,
                  margin: EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0)),
                  child: ListTile(
                    title: Text('Title'),
                  ),
                ),
                Expanded(
                    child: SingleChildScrollView(
                  child: Text('''
                    description text
                    '''),
                ))
              ],
            ),
          ),
        );
      },
    )
```

### Social media like page

```dart
//Create a global FlickMultiManager instance;
FlickMultiManager flickMultiManager = FlickMultiManager();
//Lsit of Url of your videos
List<String> videoURLList = [
'https://assets.mixkit.co/videos/preview/mixkit-healthy-woman-jumping-a-rope-40234-large.mp4',
'https://assets.mixkit.co/videos/preview/mixkit-exercising-by-climbing-the-steps-of-some-bleachers-40758-large.mp4',
'https://assets.mixkit.co/videos/preview/mixkit-girl-doing-sit-ups-lying-on-the-floor-4591-large.mp4',
'https://assets.mixkit.co/videos/preview/mixkit-woman-working-out-with-dumbbells-1313-large.mp4',
'https://assets.mixkit.co/videos/preview/mixkit-woman-doing-mountain-climber-exercise-726-large.mp4',
  ];
ListView.builder(
        itemCount: videoURLList.length,
        itemBuilder: (context, index) => AveoFeedPlayer(
            url: videoURLList[index],
            flickMultiManager: flickMultiManager),
      )
```

## Additional information

This package is developed and maintained by [AveoSoft Pvt Ltd](https://aveosoft.com/).
For any issues & improvements you can create an issue in Github Issues.
