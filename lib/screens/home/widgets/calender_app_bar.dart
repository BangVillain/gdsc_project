import 'package:flutter/material.dart';

import '../../../config/colors/app_colors.dart';

class CalenderAppBar extends StatelessWidget {
  const CalenderAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 6)],
        ),
        child: const Text(
          'Diary Calender',
          style: TextStyle(
              fontSize: 20,
              color: AppColors.cappuccino1,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
