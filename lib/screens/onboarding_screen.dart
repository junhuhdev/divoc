import 'package:divoc/common/loader.dart';
import 'package:divoc/screens/home_screen.dart';
import 'package:divoc/screens/login_screen.dart';
import 'package:divoc/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();
  AuthService authService = AuthService();

  /// TODO: maybe remove isloading reason was to minimize

  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => LoginScreen()),
    );
  }

  Widget _buildImage(String assetName) {
    return Align(
      child: Image.asset('assets/onboarding/$assetName.jpg', width: 350.0),
      alignment: Alignment.bottomCenter,
    );
  }

  @override
  void initState() {
    super.initState();
    authService.getCurrentUser.then((user) {
      if (user != null) {
        Navigator.pushReplacementNamed(context, HomeScreen.id);
      }
    });
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
            title: "Gå med Divoc idag!",
            bodyWidget: Text('Divoc matchar personer som vill hjälpa med personer som vill ha hjälp. Tillsammans minskar vi belastningen på vård och omsorg – och räddar liv!', softWrap: true,),
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
