part of 'package:aveoplayer/aveoplayer.dart';

class DefaultLoading extends StatelessWidget {
  const DefaultLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AspectRatio(
      aspectRatio: 16 / 9,
      child: ColoredBox(
        color: Colors.black,
        child: Center(
            child: SizedBox.square(
                dimension: 60,
                child: CircularProgressIndicator(color: Color(0xb1ffffff)))),
      ),
    );
  }
}
