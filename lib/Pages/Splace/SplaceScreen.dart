import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:chitchat/Pages/WelcomePage/Welcome.dart';
import 'package:chitchat/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplaceScreen extends StatelessWidget {
  const SplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: LottieBuilder.asset(
            "assets/animation/Animation - 1727089091164.json",
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.contain,
          ),
        ),
      ),
      nextScreen: const Welcome(),
      backgroundColor: dContainerColor,
      splashIconSize: 400,
    );
  }
}
