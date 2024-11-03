import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../config/colors/app_colors.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 3)]),
        child: const Text(
          '그림 일기장',
          style: TextStyle(
              fontSize: 20,
              color: AppColors.grey5,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
