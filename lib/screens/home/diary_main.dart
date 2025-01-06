import 'package:flutter/material.dart';

class DiaryMain extends StatelessWidget {
  const DiaryMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container( // 다이어리 디자인 시작
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
          ),    // 다이어리 디자인 끝
          child: PageView.builder(  // 좌우로 스크롤 가능한 위젯 생성
            itemCount: 5, // 페이지 수
            itemBuilder: (context, index) {
              return Container(   
                margin: const EdgeInsets.all(8.0),    // 페이지 디자인 시작
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255), // 다이어리 내용 색깔
                  border: Border(
                    right: BorderSide(
                      color: Colors.brown[200]!,
                      width: 1.0,
                    ),
                  ),
                ),    //페이지 디자인 끝
                child: Padding(
                  padding: const EdgeInsets.all(16.0),    // 모든 방향에 16픽셀 패딩 추가
                  child: Column(    // 위젯 세로 배치
                    crossAxisAlignment: CrossAxisAlignment.start,   // 컬럼 내 위젯들을 왼쪽 정렬
                    children: [
                      Text(   // 각 페이지 제목
                        '${index + 1}번째 페이지',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),   // 제목이랑 내용 줄 간격 띄우는 용도로 만든 박스 위젯
                      Expanded(     // 남은 공간을 모두 차지하는 위젯
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