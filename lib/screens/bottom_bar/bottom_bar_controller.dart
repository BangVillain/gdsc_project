import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gdsc_project/screens/bottom_bar/bottom_bar_widget.dart';
import 'package:gdsc_project/screens/home/home_screen.dart';
//import '../home/home_screen.dart';

class BottomBarController extends StatelessWidget {
  const BottomBarController({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: TabBarView(
            physics: NeverScrollableScrollPhysics(), //가로 스크롤 막기
            children: [
              SafeArea(
                  child: Center(
                      child: Text("도감", style: TextStyle(fontSize: 32)))),
              SafeArea(
                  child: Center(
                      child: Text("캘린더", style: TextStyle(fontSize: 32)))),
              HomeScreen(),
              SafeArea(
                  child: Center(
                      child: Text("즐겨찾기", style: TextStyle(fontSize: 32)))),
              SafeArea(
                  child: Center(
                      child: Text("설정", style: TextStyle(fontSize: 32)))),
            ]),
        bottomNavigationBar: BottomBarWidget(),
      ),
    );
  }
}
