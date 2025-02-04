import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../goto_welcome_listener.dart';
import '../home/home.dart';
import '../login/login_page.dart';
import '../welcome/welcome_page.dart';
import 'onboarding_animation.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> with TickerProviderStateMixin implements GoToLoginListener, GoToWelcomeListener{

  late AnimationController animationControllerWelcome;
  late AnimationController animationControllerLogin;

  late OnBoardingEnterAnimation onBoardingEnterAnimation;
  
  late int _contentScreenState;

  @override
  void initState() {
    super.initState();
    checkExistingToken();
    animationControllerLogin =  AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this)
      ..addStatusListener((AnimationStatus status) {
        switch (status) {
          case AnimationStatus.forward:
            break;
          case AnimationStatus.reverse:
            break;
          case AnimationStatus.completed:
            break;
          case AnimationStatus.dismissed:
            setState(() {
              _contentScreenState = 1;
            });
            animationControllerWelcome.forward();
            break;
        }
      })..addListener(() {
        setState(() {

        });
      });

    animationControllerWelcome =  AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this)
      ..addStatusListener((AnimationStatus status) {
        switch (status) {
          case AnimationStatus.forward:
            break;
          case AnimationStatus.reverse:
            break;
          case AnimationStatus.completed:
            break;
          case AnimationStatus.dismissed:
            setState(() {
              _contentScreenState = 2;
            });
            animationControllerLogin.forward();
            break;
        }
      })..addListener(() {
        setState(() {

        });
      });

    setState(() {
      _contentScreenState = 1;
    });

    onBoardingEnterAnimation = OnBoardingEnterAnimation(animationControllerLogin);

    animationControllerWelcome.forward();
  }

  @override
  void dispose() {
    animationControllerWelcome.dispose();
    animationControllerLogin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: onBoardingEnterAnimation.colorAnimation.value,
      body: getCurrentWidget()
    );
  }

  @override
  void onGoAheadTap() {
    animationControllerWelcome.reverse();
  }

  Widget getCurrentWidget() {
    switch(_contentScreenState) {
      case 1: return WelcomePage(controller: animationControllerWelcome, goTOLoginListener: this);
      case 2: return LoginPage(controller: animationControllerLogin, goToWelcomeListener: this);
      default: return const Offstage();
    }
  }

  @override
  void onGoToWelcomeTap() {
    animationControllerLogin.reverse();
  }

  Future<void> checkExistingToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? existingToken = prefs.getString('tokenmobile');

    if (existingToken != null) {
      // Direct the user to the Dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Dashboard(),
        ),
      );
    }
   
  }
}
