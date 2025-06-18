import 'dart:math';
class YoutubeApiClient {
  final Map<String, dynamic> payload;
  final String apiUrl;
  final Map<String, dynamic> headers;

  const YoutubeApiClient(this.payload, this.apiUrl, {this.headers = const {}});

  YoutubeApiClient.fromJson(Map<String, dynamic> json)
      : payload = json['payload'],
        apiUrl = json['apiUrl'],
        headers = json['headers'];

  Map<String, dynamic> toJson() => {
        'payload': payload,
        'apiUrl': apiUrl,
        'headers': headers,
      };

  // from https://github.com/yt-dlp/yt-dlp/blob/7794374de8afb20499b023107e2abfd4e6b93ee4/yt_dlp/extractor/youtube/_base.py#L136
  /// Has limited streams but doesn't require signature deciphering.
 
static final ios = (() {
  final random = Random();
  final major = 20;
  final minor = random.nextInt(30) + 1;
  final patch = random.nextInt(10);
  final version = '$major.$minor.$patch';
  final deviceModel = 'iPhone${14 + random.nextInt(4)},${random.nextInt(4) + 1}';
  final osVersion = '18.${random.nextInt(5)}.${random.nextInt(99)}';

  return YoutubeApiClient({
    'context': {
      'client': {
        'clientName': 'IOS',
        'clientVersion': version,
        'deviceMake': 'Apple',
        'deviceModel': deviceModel,
        'userAgent':
            'com.google.ios.youtube/$version ($deviceModel; U; CPU iOS 18_3_2 like Mac OS X;)',
        'hl': 'en',
        "platform": "MOBILE",
        'osName': 'IOS',
        'osVersion': osVersion,
        'timeZone': 'UTC',
        'gl': 'US',
        'utcOffsetMinutes': 0
      }
    },
  }, 'https://www.youtube.com/youtubei/v1/player?key=AIzaSyB-63vPrdThhKuerbB2N_l7Kwwcxj6yUAc&prettyPrint=false', headers: {
    'Content-Type': 'application/json',
    'Origin': 'https://www.youtube.com',
    'User-Agent':
        'com.google.ios.youtube/$version ($deviceModel; U; CPU iOS 18_3_2 like Mac OS X;)',

    // Insert your full, valid YouTube cookies here:
    'Cookie': 'LOGIN_INFO=AFmmF2swRQIgKGP9Qc4c_JSBr3JDW03IIK_lb6FimOyIYtxUJmKYIgECIQCQYge5iBtxNg_YJlJ5kcEGUGjgVh-KKtfnlZXAcBOQZg:QUQ3MjNmeEktdWJSdFlZV2hTUEdQOG9iSENZZ3hPXy14MUNHaDF2c1NRc1JDSy1Kd2FGZVZ2MTVqZjdDaFg4TExjc2pGSjJDUkdkRk1NU2FWR1RyUUNOVUFsaEtRcGFDcHdmeE5iQV8zSl9wcTI5eFJQczNhQzlLMklGX05BR3UzWXNmUnU3TnNCTGN5N1Y0Q09yX2lYM2tRZWhHYjZlb0lR; VISITOR_INFO1_LIVE=b9gKi5jBfiU; VISITOR_PRIVACY_METADATA=CgJQSxIEGgAgOQ%3D%3D; SID=g.a000xQiM13KDXa44t7rv7KDxcyAQIaEzLEf1Z5iXyXaWPa_E0KfqPBpF20mfLremKLHl_p_7QgACgYKAacSARQSFQHGX2MibZ2Q3ycMyKOrIlQ8QZviBRoVAUF8yKrhSBA_c0zGilB-SFuriPQD0076; __Secure-1PSID=g.a000xQiM13KDXa44t7rv7KDxcyAQIaEzLEf1Z5iXyXaWPa_E0KfqSlt1J3DvzfI7FCmQxosctwACgYKAbsSARQSFQHGX2MiuQt5RUgBosblK-W-kzR3XRoVAUF8yKp_gLIMT60q_hQk05c4IF0a0076; __Secure-3PSID=g.a000xQiM13KDXa44t7rv7KDxcyAQIaEzLEf1Z5iXyXaWPa_E0KfqJbOnrZibqKc10znchZTmBAACgYKAcgSARQSFQHGX2MiFZIkDt6-Q3FKGnvCzheB7RoVAUF8yKprPeqXHK6kLjjajL8buhX30076; HSID=AQRM7kfT0klVdejUu; SSID=AyrtsnJlL5VtpEQw8; APISID=eWBITK-BqGLFzwt8/Ak1utx1_IzgdAg8wN; SAPISID=C85_wOpQCTSSG8Fm/AW-I46I53dShBh9vH; __Secure-1PAPISID=C85_wOpQCTSSG8Fm/AW-I46I53dShBh9vH; __Secure-3PAPISID=C85_wOpQCTSSG8Fm/AW-I46I53dShBh9vH; YSC=ffi8T050DMc; __Secure-ROLLOUT_TOKEN=CMeO85Oy8bLb4gEQ39PQrofFjAMY4aC6h7H6jQM%3D; PREF=f6=40000000&tz=Asia.Karachi&f5=30000&f7=100&f4=4000000; __Secure-1PSIDTS=sidts-CjEB5H03P6tAz7tnCKaFBNVgABwfhuZySYyhZXBEO0Cf7nXGbbAuRule_eiOfz4b9Qx3EAA; __Secure-3PSIDTS=sidts-CjEB5H03P6tAz7tnCKaFBNVgABwfhuZySYyhZXBEO0Cf7nXGbbAuRule_eiOfz4b9Qx3EAA; SIDCC=AKEyXzWRCEV69aK0KLzMAmtzZfiWnparhRDa26UigZAW4NWpFJgFkDiX6-AQOx6qYE6jh_z39JU; __Secure-1PSIDCC=AKEyXzUYB7s1o-EogypAZjot4bre5HGtVzEW2pWmgOEBrVfTCwYB9M1uKcPn3_7xDeDV0GcpSUQ; __Secure-3PSIDCC=AKEyXzUamjhQdEU-P9eQb_0_cxPGUKYf2Pn4IdsNyQnKkKcJEJaAifzkEz6hhPCT2Rik3MEzp0A'
  });
})();


  /// This provides also muxed streams but seems less reliable than [ios].
  /// If you require an android client use [androidVr] instead.
  static const android = YoutubeApiClient({
    'context': {
      'client': {
        'clientName': 'ANDROID',
        'clientVersion': '19.09.37',
        'androidSdkVersion': 30,
        'userAgent':
            'com.google.android.youtube/19.09.37 (Linux; U; Android 11) gzip',
        'hl': 'en',
        'timeZone': 'UTC',
        'utcOffsetMinutes': 0,
      },
    },
  }, 'https://www.youtube.com/youtubei/v1/player?prettyPrint=false');

  /// Has limited streams but doesn't require signature deciphering.
  /// As opposed to [android], this works only for music.
  static const androidMusic = YoutubeApiClient({
    'context': {
      'client': {
        'clientName': 'ANDROID_MUSIC',
        'clientVersion': '2.16.032',
        'androidSdkVersion': 31,
        'userAgent':
            'com.google.android.youtube/19.29.1  (Linux; U; Android 11) gzip',
        'hl': 'en',
        'timeZone': 'UTC',
        'utcOffsetMinutes': 0,
      },
    },
  }, 'https://music.youtube.com/youtubei/v1/player?key=AIzaSyAOghZGza2MQSZkY_zfZ370N-PUdXEo8AI&prettyPrint=false');

  /// Provides high quality videos (not only VR).
  static const androidVr = YoutubeApiClient({
    'context': {
      'client': {
        'clientName': 'ANDROID_VR',
        'clientVersion': '1.56.21',
        'deviceModel': 'Quest 3',
        'osVersion': '12',
        'osName': 'Android',
        'androidSdkVersion': '32',
        'hl': 'en',
        'timeZone': 'UTC',
        'utcOffsetMinutes': 0,
      },
    },
  }, 'https://www.youtube.com/youtubei/v1/player?prettyPrint=false');

  /// This client also provide high quality muxed stream in the HLS manifest.
  /// The streams are in m3u8 format.
  static const safari = YoutubeApiClient({
    'context': {
      'client': {
        'clientName': 'WEB',
        'clientVersion': '2.20250312.04.00',
        'userAgent':
            'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.5 Safari/605.1.15,gzip(gfe)',
        'hl': 'en',
        'timeZone': 'UTC',
        'utcOffsetMinutes': 0,
      },
    },
  }, 'https://www.youtube.com/youtubei/v1/player?prettyPrint=false');

  /// Used to bypass same restriction on videos.
  static const tv = YoutubeApiClient(
      {
        'context': {
          'client': {
            'clientName': 'TVHTML5',
            'clientVersion': '7.20240724.13.00',
            'hl': 'en',
            'timeZone': 'UTC',
            'gl': 'US',
            'utcOffsetMinutes': 0
          }
        },
        "contentCheckOk": true,
        "racyCheckOk": true
      },
      'https://www.youtube.com/youtubei/v1/player?prettyPrint=false',
      headers: {
        'Sec-Fetch-Mode': 'navigate',
        'Content-Type': 'application/json',
        'Origin': 'https://www.youtube.com',
      });

  static const mediaConnect = YoutubeApiClient({
    'context': {
      'client': {
        'clientName': 'MEDIA_CONNECT_FRONTEND',
        'clientVersion': '0.1',
        'hl': 'en',
        'timeZone': 'UTC',
        'utcOffsetMinutes': 0,
      },
    },
  }, 'https://www.youtube.com/youtubei/v1/player?prettyPrint=false');

  /// Sometimes includes low quality streams (eg. 144p12).
  static const mweb = YoutubeApiClient({
    'context': {
      'client': {
        'clientName': 'MWEB',
        'clientVersion': '2.20240726.01.00',
        'hl': 'en',
        'timeZone': 'UTC',
        'utcOffsetMinutes': 0,
      },
    },
  }, 'https://www.youtube.com/youtubei/v1/player?prettyPrint=false');

  @Deprecated('Youtube always requires authentication for this client')
  static const webCreator = YoutubeApiClient({
    'context': {
      'client': {
        'clientName': 'WEB_CREATOR',
        'clientVersion': '1.20240723.03.00',
        'hl': 'en',
        'timeZone': 'UTC',
        'utcOffsetMinutes': 0,
      },
    },
  }, 'https://www.youtube.com/youtubei/v1/player?prettyPrint=false');

  /// Work even of restricted videos and provides low quality muxed streams, but requires signature deciphering.
  /// Does not work if the video has the embedding disabled.
  @Deprecated('Youtube always requires authentication for this client')
  static const tvSimplyEmbedded = YoutubeApiClient(
      {
        'context': {
          'client': {
            'clientName': 'TVHTML5_SIMPLY_EMBEDDED_PLAYER',
            'clientVersion': '2.0',
            'hl': 'en',
            'timeZone': 'UTC',
            'gl': 'US',
            'utcOffsetMinutes': 0
          }
        },
        'thirdParty': {'embedUrl': 'https://www.youtube.com/'},
        'contentCheckOk': true,
        'racyCheckOk': true
      },
      'https://www.youtube.com/youtubei/v1/player?prettyPrint=false',
      headers: {
        'Sec-Fetch-Mode': 'navigate',
        'Content-Type': 'application/json',
        'Origin': 'https://www.youtube.com',
      });
}
