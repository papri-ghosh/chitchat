import 'package:chitchat/Pages/Home/homePage.dart';
import 'package:chitchat/Pages/WelcomePage/Welcome.dart';
import 'package:chitchat/Pages/auth/authPage.dart';
import 'package:chitchat/Pages/auth/widgets/CompleteProfile.dart';
import 'package:chitchat/Pages/profile/profilePage.dart';
import 'package:get/get.dart';

var pagePath = [
  GetPage(
      name: "/authPage",
      page: () => AuthPage(),
      transition: Transition.rightToLeft),


  GetPage(
      name: "/welcomePage",
      page: () => Welcome(),
      transition: Transition.rightToLeft),

  // GetPage(
  //     name: "/profilePage",
  //     page: () => ProfilePage(),
  //     transition: Transition.rightToLeft),

            
 

];
