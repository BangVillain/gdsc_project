import 'package:flutter/material.dart';
import 'package:gdsc_project/screens/bottom_bar/bottom_bar_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BottomBarController(),
    );
  }
}

//https://github.com/BangVillain/gdsc_project.git
