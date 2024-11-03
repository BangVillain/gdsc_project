import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../config/colors/app_colors.dart';

class BottomBarWidget extends StatelessWidget {
  const BottomBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(blurRadius: 1, color: Colors.grey)],
      ),
      child: const TabBar(
        tabs: [
          Tab(icon: Icon(Icons.book, size: 24), text: '도감'),
          Tab(icon: Icon(Icons.calendar_today, size: 24), text: '캘린더'),
          Tab(icon: Icon(Icons.home, size: 24), text: '홈'),
          Tab(icon: Icon(Icons.star, size: 24), text: '즐겨찾기'),
          Tab(icon: Icon(Icons.settings, size: 24), text: '설정'),
        ],
        labelColor: AppColors.main,
        unselectedLabelColor: AppColors.grey5,
        labelStyle: TextStyle(fontSize: 16), // 메뉴 글씨 스타일
        indicatorColor: Colors.transparent,
      ),
    );
  }
}
