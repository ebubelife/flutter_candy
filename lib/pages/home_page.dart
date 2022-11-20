// @dart=2.9
import 'dart:io';

import 'package:flutter_candy/animations/shine_effect.dart';
import 'package:flutter_candy/bloc/bloc_provider.dart';
import 'package:flutter_candy/bloc/game_bloc.dart';
import 'package:flutter_candy/game_widgets/double_curved_container.dart';
import 'package:flutter_candy/game_widgets/game_level_button.dart';
import 'package:flutter_candy/game_widgets/shadowed_text.dart';
import 'package:flutter_candy/model/level.dart';
import 'package:flutter_candy/pages/game_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_candy/ad_helper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_candy/helpers/audio.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  BannerAd _bannerAd;

  //Googl ads variables for interstitial ads

  InterstitialAd _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  int maxFailedLoadAttempts = 3;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    )..addListener(() {
        setState(() {});
      });

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.6,
          1.0,
          curve: Curves.easeInOut,
        ),
      ),
    );

    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });

    MobileAds.instance
      ..initialize()
      ..updateRequestConfiguration(RequestConfiguration(
          testDeviceIds: ['86E14981427A5FB20C128519DC42A6E5']));

    Audio.playAsset(AudioType.game_start);
  }

  @override
  void dispose() {
    _controller?.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  //Create google interstitial ads

  void _createInterstitialAd(Level level) {
    InterstitialAd.load(
      adUnitId: "ca-app-pub-3940256099942544/1033173712",
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _numInterstitialLoadAttempts = 0;
          _showInterstitialAd(level);
        },
        onAdFailedToLoad: (LoadAdError error) {
          _numInterstitialLoadAttempts += 1;
          _interstitialAd = null;
          if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
            _createInterstitialAd(level);
          } else {
           /* Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => GamePage()),
              (route) => false,
            );*/

            Navigator.of(context).push(GamePage.route(level));
          }
        },
      ),
    );
  }

//show google interstitial ads
  void _showInterstitialAd(Level level) {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
       /* Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => GamePage()),
          (route) => false,
        );*/
           Navigator.of(context).push(GamePage.route(level));

      },
    );
    _interstitialAd.show();
    _interstitialAd = null;
  }

  @override
  Widget build(BuildContext context) {
    GameBloc gameBloc = BlocProvider.of<GameBloc>(context);

    MediaQueryData mediaQueryData = MediaQuery.of(context);
    Size screenSize = mediaQueryData.size;
    double levelsWidth = -100.0 +
        ((mediaQueryData.orientation == Orientation.portrait)
            ? screenSize.width
            : screenSize.height);

    return Scaffold(
      body: WillPopScope(
        // No way to get back
        onWillPop: () async => false,
        child: Stack(
          children: <Widget>[
            if (_bannerAd != null)
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: _bannerAd.size.width.toDouble(),
                  height: _bannerAd.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd),
                ),
              ),
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background/background2.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ShadowedText(
                  text: 'Kodeblooded Game Studios',
                  color: Colors.white,
                  fontSize: 12.0,
                  offset: Offset(1.0, 1.0),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Container(
                  width: levelsWidth,
                  height: levelsWidth,
                  child: GridView.builder(
                    itemCount: gameBloc?.numberOfLevels,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1.01,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return GameLevelButton(
                        width: 80.0,
                        height: 60.0,
                        borderRadius: 50.0,
                        text: 'Level ${index + 1}',
                        onTap: () async {
                          Level newLevel = await gameBloc?.setLevel(index + 1);

                          _createInterstitialAd(newLevel);
                          // Open the Game page
                          //Navigator.of(context).push(GamePage.route(newLevel));
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0.0,
              top: _animation.value * 250.0 - 150.0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: DoubleCurvedContainer(
                  width: screenSize.width - 60.0,
                  height: 150.0,
                  outerColor: Color.fromARGB(255, 255, 145, 93),
                  innerColor: Color.fromARGB(255, 155, 36, 0),
                  child: Stack(
                    children: <Widget>[
                      ShineEffect(
                        offset: Offset(100.0, 100.0),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: ShadowedText(
                          text: 'Fruity Crush',
                          color: Colors.white,
                          fontSize: 26.0,
                          shadowOpacity: 1.0,
                          offset: Offset(1.0, 1.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      print("My device ID" + androidDeviceInfo.androidId);
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }
}
