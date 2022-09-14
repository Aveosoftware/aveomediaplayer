import 'dart:convert';

import 'package:aveoplayer/aveoplayer.dart';
import 'package:http/http.dart' as http;

/// Getting data of public video from vimeo server.
class NoneAuthApiService {
  /// id : video id
  Future<dynamic> getVimeoData({required String id}) async {
    Uri uri = Uri.parse('https://player.vimeo.com/video/$id/config');
    var res = await http.get(uri);
    if (res.statusCode != 200) {
      throw VimeoError(
          error: res.reasonPhrase,
          developerMessage:
              'Please check your video id\nand accessibility is public',
          errorCode: res.statusCode);
    }

    return jsonDecode(res.body);
  }
}
