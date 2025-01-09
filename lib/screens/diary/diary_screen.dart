import 'package:flutter/material.dart';

class DiaryScreen extends StatelessWidget {
  const DiaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('일기장'),
      ),
      body: Column(
        children: [
          // 화면의 윗부분 그림 공간
          const Spacer(flex: 1),

          // 텍스트 박스 화면 아래 위치 설정
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: '내용을 적으세요',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                style: const TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),
          ),

          // 완료 버튼
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0), // 버튼 아래 패딩 추가
            child: SizedBox(
              width: double.infinity, // 버튼 크기 화면 전체 너비로 설정
              child: ElevatedButton(
                onPressed: () {
                  // 버튼 클릭 시 동작
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: const Text("일기가 저장되었습니다!"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("확인"),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  '저장하기',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* 텍스트 박스 아래 위치
          // 텍스트 박스 아래 고정
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              constraints: const BoxConstraints(
                maxHeight: 200,
              ),
              child: SingleChildScrollView(
                reverse: true,
                child: TextField(
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: '내용을 적으세요',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
          ),
          // 완료 버튼

        ],
      ),
    );
  }
}

 */
