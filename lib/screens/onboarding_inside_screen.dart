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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Så funkar Divoc'),
        centerTitle: true,
      ),
      body: IntroductionScreen(
        pages: [
          PageViewModel(
            title: "Gå med Divoc idag!",
            body:
                'Divoc matchar personer som vill hjälpa med personer som vill ha hjälp. \n\nTillsammans minskar vi belastningen på vård och omsorg – och räddar liv!',
            image: _buildImage('img3'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Är du en mottagare?",
            body: "Ditt hjälteuppdrag är att hålla dig hemma. Använd Divoc för att låta någon hjälpa dig!",
            image: _buildImage('img1'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Är du en hjälpare?",
            body: "Fantastiskt! Då kan Divoc hjälpa dig att hitta personer som vill ha din hjälp.",
            image: _buildImage('img2'),
            decoration: pageDecoration,
          ),
        ],
        onDone: () => _onIntroEnd(context),
        //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
        showSkipButton: true,
        skipFlex: 0,
        nextFlex: 0,
        skip: const Text('SKIPPA'),
        next: const Text('FORTSÄTT'),
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
