import 'package:chitchat/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';
class StoryPage extends StatefulWidget {
  const StoryPage({super.key});

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
    StoryController storyController = StoryController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoryView(
        repeat: true,
        storyItems: [
    
        StoryItem.text(title: "This is ChitChat App",textStyle: TextStyle(fontSize: 25),
               backgroundColor: dPrimaryColor),
         StoryItem.text(title: "Let's Talk together", backgroundColor: Colors.purpleAccent, textStyle: TextStyle(fontSize: 25)),
        StoryItem.text(title: "This is our Minor Project", backgroundColor: Colors.amber, textStyle: TextStyle(fontSize: 25)),
        StoryItem.text(title: "Project Made by Papri, Sristy and Shubhasree", backgroundColor: Colors.lime, textStyle: TextStyle(fontSize: 25)),
       


      ], 
      controller: storyController,
   ),
    );
  }
}