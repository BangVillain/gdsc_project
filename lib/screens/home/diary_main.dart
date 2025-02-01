import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'home_calender.dart';

class DiaryMain extends StatefulWidget {
  const DiaryMain({super.key});

  @override
  _DiaryMainState createState() => _DiaryMainState();
}

class _DiaryMainState extends State<DiaryMain> {
  List<dynamic> _diaryEntries = [];
  bool isLoading = true;
  late PageController _pageController;
  int _currentPage = 0; // 현재 페이지(일기) 인덱스

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _fetchDiaryEntries();
  }

  Future<void> _fetchDiaryEntries() async {
    final url = Uri.parse('http://52.79.42.44:8080/getdiary');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decodedResponse = utf8.decode(response.bodyBytes);
        final data = jsonDecode(decodedResponse);
        setState(() {
          _diaryEntries = data['diary'];
          // 날짜순 정렬 (오름차순)
          _diaryEntries.sort((a, b) =>
              DateTime.parse(a['date']).compareTo(DateTime.parse(b['date'])));
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Center 내부에 Column으로 PageView와 전체화면 버튼 배치
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
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
                      controller: _pageController,
                      itemCount: _diaryEntries.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        final entry = _diaryEntries[index];
                        return Container(
                          margin: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 255, 255),
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
                                  entry['title'],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Expanded(
                                  child: Text(
                                    entry['content'],
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                                Text(
                                  entry['date'],
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.fullscreen),
                    label: const Text("전체화면"),
                    onPressed: () {
                      // 현재 페이지의 일기 정보를 가져옴
                      final entry = _diaryEntries[_currentPage];
                      // 일기 날짜 문자열을 DateTime으로 변환 (예: "2023-07-28")
                      DateTime diaryDate = DateTime.parse(entry['date']);
                      // HomeCalendar 화면으로 이동하면서 선택 날짜와 전체화면 모드(true)를 전달
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeCalendar(
                            initialSelectedDate: diaryDate,
                            initialExpanded: true,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
