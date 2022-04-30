
import 'package:flutter/material.dart';
import './ad_helper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import './mysplash.dart';

class StartPage extends StatefulWidget {
  static const routeName = '/start-page';

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  BannerAd _bannerAd;
  
  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      //adUnitId: BannerAd.testAdUnitId,
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: AdListener(
        onAdLoaded: (Ad ad) {
          print('$BannerAd loaded.');
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$BannerAd failedToLoad: $error');
        },
        onAdOpened: (Ad ad) => print('$BannerAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$BannerAd onAdClosed.'),
        onApplicationExit: (Ad ad) => print('$BannerAd onApplicationExit.'),
      ),
    );

    _bannerAd?.load();
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd?.dispose();
    _bannerAd = null;
  }

  @override
  Widget build(BuildContext context) {
    final AdWidget adWidget = AdWidget(ad: _bannerAd);

    return new Scaffold(
      /*  appBar: AppBar(
        title: const Text('Google Mobile Ads'),
        actions: <Widget>[
          
        ],
      ), */
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(MySplash.routeName);
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * (10.0 / 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: new AssetImage("assets/images/detect.png"))),
                  child: Align(
                    alignment: FractionalOffset.topCenter,
                    child: Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Column(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.center,
                              child: adWidget,
                              width: _bannerAd.size.width.toDouble(),
                              height: _bannerAd.size.height.toDouble(),
                            ),
                            /* if (_bannerAd.size.height.toDouble() >=
                                MediaQuery.of(context).size.height * (1.0 / 2))
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(MySplash.routeName);
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width - 260,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 24.0, vertical: 17.0),
                                  decoration: BoxDecoration(
                                      color: Color(0xff7170b9),
                                      borderRadius: BorderRadius.circular(6.0)),
                                  child: Text(
                                    "Click",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ), */
                          ],
                        )),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
