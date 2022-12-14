part of 'package:aveoplayer/aveoplayer.dart';

/// Error on getting vimeo meta data from vimeo server.
class VimeoError extends Error {
  final String? error;
  final String? link;
  final String? developerMessage;
  final int? errorCode;

  VimeoError({this.error, this.link, this.developerMessage, this.errorCode});

  @override
  String toString() {
    if (error != null) {
      return 'getting vimeo information failed: ${Error.safeToString(error)}';
    }
    return 'getting vimeo information failed';
  }

  factory VimeoError.fromJsonAuth(Map<String, dynamic> json) {
    return VimeoError(
      error: json['error'],
      link: json['link'],
      developerMessage: json['developer_message'],
      errorCode: json['error_code'],
    );
  }

  factory VimeoError.fromJsonNoneAuth(Map<String, dynamic> json) {
    return VimeoError(
      error: json['message'],
      link: null,
      developerMessage: json['title'],
      errorCode: null,
    );
  }
}

class VimeoException implements Exception {
  final VimeoError vimeoError;
  VimeoException(this.vimeoError);

  @override
  String toString() {
    return vimeoError.toString();
  }
}
