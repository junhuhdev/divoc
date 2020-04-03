import 'package:divoc/common/loader.dart';
import 'package:divoc/screens/home_screen.dart';
import 'package:divoc/screens/login_screen.dart';
import 'package:divoc/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnboardingInsideScreen extends StatefulWidget {
  @override
  _OnboardingInsideScreenState createState() => _OnboardingInsideScreenState();
}

class _OnboardingInsideScreenState extends State<OnboardingInsideScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.pop(context);
  }

  Widget _buildImage(String assetName) {
    return Align(
      child: Image.asset('assets/onboarding/$assetName.jpg', width: 350.0),
      alignment: Alignment.bottomCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return Container(
      child: IntroductionScreen(
        pages: [
          PageViewModel(
            title: "Är du i riskgruppen?",
            body: "Bli en Hemmahjälte genom att inte gå till affären!",
            image: _buildImage('img1'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Inte i riskgruppen?",
            body: "Registrera dig som medhjälpare och rädda liv genom att handla åt andra!",
            image: _buildImage('img2'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Gå med Divoc idag",
            body:
                "Divoc möjliggör gratis hemleveranser av mat- och apoteksvaror till riskgrupper. Vi hjälper personer i riskgrupper att stanna hemma genom att sammanföra dem med verifierade medhjälpare. Tillsammans minskar vi belastningen på vården och räddar liv!.",
            image: _buildImage('img3'),
            decoration: pageDecoration,
          ),
        ],
        onDone: () => _onIntroEnd(context),
        //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
        showSkipButton: true,
        skipFlex: 0,
        nextFlex: 0,
        skip: const Text('SKIPPA'),
        next: const Icon(Icons.arrow_forward),
        done: const Text('KLAR', style: TextStyle(fontWeight: FontWeight.w600)),
        dotsDecorator: const DotsDecorator(
          size: Size(10.0, 10.0),
          color: Color(0xFFBDBDBD),
          activeSize: Size(22.0, 10.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
        ),
      ),
    );
  }
}
