import 'package:chitchat/config/image.dart';
import 'package:chitchat/config/string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


class WelcomeHeading extends StatelessWidget {
  const WelcomeHeading({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(AssetsImage.appIocnSVG, height: 80,), //heading
              ],
            ),
            SizedBox(height: 20,),
            Text(AppString.appName, style: Theme.of(context).textTheme.headlineLarge)
      ],
    );
  }
}