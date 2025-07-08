import 'package:flutter/material.dart';
class Phone_Call extends StatefulWidget {
  const Phone_Call({super.key});

  @override
  State<Phone_Call> createState() => _Phone_CallState();
}

class _Phone_CallState extends State<Phone_Call> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(child: Text("data")),
    );
  }
}