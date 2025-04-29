import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:triptale/src/presentation/user_auth/sign_up.dart';

import 'src/app.dart';
import 'src/presentation/home/home_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      backgroundColor: Colors.deepPurpleAccent,
      splash: Column(
        children: [
          Center(
            child: LottieBuilder.asset(
                "assets/lottie/Animation - 1743587126707.json"),
          )
        ],
      ),
      nextScreen: HomePage(),
      splashIconSize: 400,
    );
  }
}

class SplashScreen1 extends StatelessWidget {
  const SplashScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      backgroundColor: Colors.deepPurpleAccent,
      splash: Column(
        children: [
          Center(
            child: LottieBuilder.asset(
                "assets/lottie/Animation - 1743587126707.json"),
          )
        ],
      ),
      nextScreen: SignUp(),
      splashIconSize: 400,
    );
  }
}
