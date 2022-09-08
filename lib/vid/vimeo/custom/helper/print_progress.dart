String printDuration(Duration? duration) {
  if (duration == null) {
    return '00:00';
  } else {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return duration.inHours == 0
        ? '$twoDigitMinutes:$twoDigitSeconds'
        : '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }
}
