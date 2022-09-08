part of 'package:aveoplayer/aveoplayer.dart';

abstract class VideoPlayerState {}

class VPError extends VideoPlayerState {
  final String error;
  VPError({required this.error});
}

class VPLoading extends VideoPlayerState {}

class VPSuccess extends VideoPlayerState {}

class _VPInit extends VideoPlayerState {}
