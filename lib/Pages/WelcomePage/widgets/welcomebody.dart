import 'package:chitchat/config/image.dart';
import 'package:chitchat/config/string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


class welcomeBody extends StatelessWidget {
  const welcomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AssetsImage.girl, height: 150, width: 120,),
              SvgPicture.asset(AssetsImage.connectSVG, height: 50),
              Image.asset(AssetsImage.boy,height: 150, width: 120,),
              
            ],

           ),
           SizedBox(height: 20,),
           Text(WelcomePageString.nowyouAre, style: Theme.of(context).textTheme.headlineMedium,),
           Text(WelcomePageString.connected, style: Theme.of(context).textTheme.headlineLarge,),
          SizedBox(height: 30,),
          Text(WelcomePageString.
          description, textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelLarge)
          ],
    );
  }
}