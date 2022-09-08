import 'dart:developer';

class PlayerAppUIUtils {
  static bool videoUrlIsYoutube(String videoUrl) {
    RegExp youtubeVideoRegex = RegExp(
        r"^((?:https?:)?\/\/)?((?:www|m)\.)?((?:youtube\.com|youtu.be))(\/(?:[\w\-]+\?v=|embed\/|v\/)?)([\w\-]+)(\S+)?$");
    return youtubeVideoRegex.hasMatch(videoUrl);
  }

  static bool videoUrlIsYoutube2(String videoUrl) {
    RegExp youtubeVideoRegex = RegExp(
        r"^((?:https?:)?\/\/)?((?:www|m)\.)?((?:youtube\.com|youtu.be))(\/(?:[\w\-]+\?v=|embed\/|v\/)?)([\w\-]+)(\S+)?$");
    return youtubeVideoRegex.hasMatch(videoUrl);
  }

  static String? convertYouTubeUrlToId(String url,
      {bool trimWhitespaces = true}) {
    // assert(url.isEmpty, 'Url cannot be empty');
    if (!url.contains("http") && (url.length == 11)) return url;
    if (trimWhitespaces) url = url.trim();

    for (var exp in [
      RegExp(
          r"^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(
          r"^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(r"^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$")
    ]) {
      RegExpMatch? match = exp.firstMatch(url);
      if (match != null && match.groupCount >= 1) return match.group(1);
    }

    return null;
  }

  static bool videoUrlIsFaceBook(String videoUrl) {
    // https://www.facebook.com/GameOfGames/videos/1159039334273808
    // RegExp videoUrlIsFaceBookRegex = RegExp(r'/(?:https?:\/{2})?(?:w{3}\.)?(facebook|fb).com/.*/videos/.*/');
    if (videoUrl.contains("https://www.facebook.com/") &&
        videoUrl.contains("videos")) {
      return true;
    } else {
      return false;
    }
    // return videoUrlIsFaceBookRegex.hasMatch(videoUrl);
  }

  static bool videoUrlIsFaceBook2(String videoUrl) {
    RegExp videoUrlIsFaceBookRegex =
        RegExp(r'/(?:https?:\/{2})?(?:w{3}\.)?(facebook|fb).com/.*/videos/.*/');
    return videoUrlIsFaceBookRegex.hasMatch(videoUrl);
  }

  static bool videoUrlIsVimeo(String url) {
    String replacedUrl;
    replacedUrl = url.replaceAll("https://", "");
    replacedUrl = replacedUrl.replaceAll("http://", "");
    replacedUrl = replacedUrl.replaceAll("www.", "");
    RegExp youtubeVideoRegex = RegExp(r'vimeo\.com/(\d+)');
    log("Package Viemo url $url");
    log("Package Viemo Replaced url $replacedUrl");
    log("Package Viemo url test ${youtubeVideoRegex.hasMatch(replacedUrl)}");
    // RegExp youtubeVideoRegex = RegExp(r'(http|https)?:\/\/(www\.)?vimeo.com\/(?:channels\/(?:\w+\/)?|groups\/([^\/]*)\/videos\/|)(\d+)(?:|\/\?)');

    return youtubeVideoRegex.hasMatch(url);
  }

  static bool videoUrlIsVimeo2(String url) {
    RegExp youtubeVideoRegex = RegExp(
        r'/https?:\/\/(?:www\.)?vimeo.com\/(?:channels\/(?:\w+\/)?|ondemand\/|ondemand\/([^\/]*)\/|groups\/([^\/]*)\/videos\/|album\/(\d+)\/video\/|)(\d+)(?:$|\/|\?)/');

    return youtubeVideoRegex.hasMatch(url);
  }

  static String convertVimeoUrlToId(String url, {bool trimWhitespaces = true}) {
    // assert(url.isEmpty, 'Url cannot be empty');

    if (trimWhitespaces) url = url.trim();

    String replacedUrl;
    replacedUrl = url.replaceAll("https://", "");
    replacedUrl = replacedUrl.replaceAll("http://", "");
    replacedUrl = replacedUrl.replaceAll("www.", "");
    RegExp youtubeVideoRegex = RegExp(r'vimeo\.com/(\d+)');
    log("Package Viemo Id extract Replaced url $replacedUrl");
    // RegExp youtubeVideoRegex = RegExp(r'(http|https)?:\/\/(www\.)?vimeo.com\/(?:channels\/(?:\w+\/)?|groups\/([^\/]*)\/videos\/|)(\d+)(?:|\/\?)');
    replacedUrl = replacedUrl.replaceAll("vimeo.com/", "");
    log("Package Viemo Id extract final url $replacedUrl");
    return replacedUrl;
  }

  static String? convertVimeoUrlToId2(String url,
      {bool trimWhitespaces = true}) {
    assert(url.isEmpty, 'Url cannot be empty');

    if (trimWhitespaces) url = url.trim();

    for (var exp in [
      RegExp(
          r'/https?:\/\/(?:www\.)?vimeo.com\/(?:channels\/(?:\w+\/)?|ondemand\/|ondemand\/([^\/]*)\/|groups\/([^\/]*)\/videos\/|album\/(\d+)\/video\/|)(\d+)(?:$|\/|\?)/')
    ]) {
      RegExpMatch? match = exp.firstMatch(url);
      if (match != null && match.groupCount >= 3) return match.group(5);
    }

    return null;
  }

  static String convertFacebookUrlToId(String url,
      {bool trimWhitespaces = true}) {
    assert(url.isEmpty, 'Url cannot be empty');

    if (trimWhitespaces) url = url.trim();

    return url.replaceAll("https://www.facebook.com/", "");

    // return null;
  }

  static String? convertFacebookUrlToId2(String url,
      {bool trimWhitespaces = true}) {
    assert(url.isEmpty, 'Url cannot be empty');

    if (trimWhitespaces) url = url.trim();

    for (var exp in [
      RegExp(r"(\d+)\/?$"),
    ]) {
      RegExpMatch? match = exp.firstMatch(url);
      return match!.group(1);
    }

    return null;
  }
}
