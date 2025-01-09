import 'package:flutter/material.dart';
import 'package:gdsc_project/screens/bottom_bar/bottom_bar_controller.dart';
import 'package:intl/date_symbol_data_local.dart'; // 올바른 경로

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 반드시 초기화
  await initializeDateFormatting('ko_KR', null);
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
