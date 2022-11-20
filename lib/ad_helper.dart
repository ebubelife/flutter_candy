import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-9670566862070106/8301707093';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-9670566862070106/8301707093';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-9670566862070106/1516806896";
    } else if (Platform.isIOS) {
      return "ca-app-pub-9670566862070106/1516806896";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-9670566862070106/6605482041";
    } else if (Platform.isIOS) {
      return "ca-app-pub-9670566862070106/6605482041";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get appOpenAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/3419835294";
    } else if (Platform.isIOS) {
      return "";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}
