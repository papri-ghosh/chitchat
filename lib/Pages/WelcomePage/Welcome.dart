import 'package:chitchat/Pages/WelcomePage/widgets/welcomeFooter.dart';
import 'package:chitchat/Pages/WelcomePage/widgets/welcomeHeading.dart';
import 'package:chitchat/Pages/WelcomePage/widgets/welcomebody.dart';
import 'package:chitchat/config/colors.dart';
import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
           WelcomeHeading(),
            welcomeBody(),
            WelcomeFooterbutton()
          ],
        ),
      )),
    );
  }
}


