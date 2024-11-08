import 'package:flutter/material.dart';

class DiaryMain extends StatelessWidget {
  const DiaryMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 300,
          height: 400,
          decoration: BoxDecoration(
            color: Colors.brown[100],
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(3, 3),
              ),
            ],
          ),
          child: PageView.builder(
            itemCount: 5, // 페이지 수
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    right: BorderSide(
                      color: Colors.brown[200]!,
                      width: 1.0,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${index + 1}번째 페이지',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: Text(
                          '여기에 다이어리 내용을 작성하세요...',
                          style: TextStyle(
                            color: Colors.grey[600],
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}