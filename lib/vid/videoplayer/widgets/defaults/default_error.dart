part of 'package:aveoplayer/aveoplayer.dart';

class DefaultError extends StatelessWidget {
  final String error;
  const DefaultError({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ColoredBox(
        color: Colors.black,
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.info,
              color: Color(0x77ffffff),
            ),
            const SizedBox.square(
              dimension: 10,
            ),
            Text(
              error,
              style: const TextStyle(color: Color(0x99ffffff)),
            )
          ],
        )),
      ),
    );
  }
}
