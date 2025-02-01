import 'package:flutter/material.dart';
import 'package:gdsc_project/config/colors/app_colors.dart';
import 'package:gdsc_project/screens/home/diary_main.dart';
import 'package:gdsc_project/screens/home/widgets/calender_app_bar.dart';
import 'package:gdsc_project/screens/diary/diary_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const IconData fullscreen_exit_rounded =
      IconData(0xf7a5, fontFamily: 'MaterialIcons');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(52), child: CalenderAppBar()),
      body: Stack(
        children: [
          const DiaryMain(), // 홈 화면에 다이어리 내용 표시
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                // 아이콘 클릭 시 이벤트 처리
              },
              backgroundColor: AppColors.grey3,
              child: Icon(fullscreen_exit_rounded, color: Colors.white),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              //버튼을 눌렀을 때의 이벤트
              context,
              MaterialPageRoute(
                builder: (context) => const DiaryScreen(), // DiaryScreen 이동
              ),
            );
          },
          backgroundColor: AppColors.grey3,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          label: const Row(
            children: [
              Icon(Icons.create_rounded, color: Colors.white, size: 24),
              SizedBox(width: 8),
              Text(
                "기록하기",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )
            ],
          )),
    );
  }
}
