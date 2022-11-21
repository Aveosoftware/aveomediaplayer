part of 'package:aveoplayer/aveoplayer.dart';

class PlaybackSpeedVimeo extends StatelessWidget {
  const PlaybackSpeedVimeo({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .35,
      color: Theme.of(context).backgroundColor,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            Container(
              height: 5,
              width: 20,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Color(0x7fffffff)),
            ),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  controller.setPlaybackSpeed(0.25);
                },
                child: Text(
                  '.25x',
                  style: greetingStyle,
                )),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                color: Color(0x7fffffff),
                height: .5,
              ),
            ),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  controller.setPlaybackSpeed(0.5);
                },
                child: Text(
                  '.5x',
                  style: greetingStyle,
                )),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                color: Color(0x7fffffff),
                height: .5,
              ),
            ),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  controller.setPlaybackSpeed(0.75);
                },
                child: Text(
                  '.75x',
                  style: greetingStyle,
                )),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                color: Color(0x7fffffff),
                height: .5,
              ),
            ),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  controller.setPlaybackSpeed(1.0);
                },
                child: Text(
                  '1x',
                  style: greetingStyle,
                )),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                color: Color(0x7fffffff),
                height: .5,
              ),
            ),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  controller.setPlaybackSpeed(1.25);
                },
                child: Text(
                  '1.25x',
                  style: greetingStyle,
                )),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                color: Color(0x7fffffff),
                height: .5,
              ),
            ),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  controller.setPlaybackSpeed(1.5);
                },
                child: Text(
                  '1.5x',
                  style: greetingStyle,
                )),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                color: Color(0x7fffffff),
                height: .5,
              ),
            ),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  controller.setPlaybackSpeed(1.75);
                },
                child: Text('1.75x', style: greetingStyle)),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                color: Color(0x7fffffff),
                height: .5,
              ),
            ),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  controller.setPlaybackSpeed(2.0);
                },
                child: Text('2x', style: greetingStyle)),
          ],
        ),
      ),
    );
  }
}

TextStyle greetingStyle = const TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w400,
  fontStyle: FontStyle.normal,
);
