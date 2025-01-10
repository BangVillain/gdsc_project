import 'package:flutter/material.dart';
import 'package:gdsc_project/screens/home/widgets/calender_app_bar.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../config/colors/app_colors.dart';

class HomeCalendar extends StatefulWidget {
  const HomeCalendar({super.key});

  @override
  _HomeCalendarState createState() => _HomeCalendarState();
}

class _HomeCalendarState extends State<HomeCalendar> {
  DateTime focusedDay = DateTime.now();
  DateTime selectedDay = DateTime.now(); // 기본적으로 오늘 날짜로 설정
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  final List<String> customWeekdays = ['일', '월', '화', '수', '목', '금', '토'];

  // 샘플 일기 데이터 (날짜별)
  Map<DateTime, Map<String, dynamic>> diaryEntries = {
    DateTime(2025, 1, 1): {
      'text': '일기 제목: 오늘은 날씨가 맑았다.',
      'image': 'assets/images/sunny.jpg', // 이미지 경로 예시
    },
    DateTime(2025, 1, 2): {
      'text': '일기 제목: 강아지와 산책을 다녀왔다.',
      'image': 'assets/images/walkdog.jpeg',
    },
  };

  Map<String, dynamic>? getDiaryEntry(DateTime day) {
    return diaryEntries[DateTime(day.year, day.month, day.day)];
  }

  // 연도와 월을 리스트로 생성
  List<int> years = List<int>.generate(11, (i) => 2020 + i); // 2020~2030
  List<int> months = List<int>.generate(12, (i) => i + 1); // 1~12

  void _onYearChanged(int? year) {
    if (year != null) {
      setState(() {
        selectedYear = year;
        focusedDay = DateTime(selectedYear, selectedMonth, 1);
      });
    }
  }

  void _onMonthChanged(int? month) {
    if (month != null) {
      setState(() {
        selectedMonth = month;
        focusedDay = DateTime(selectedYear, selectedMonth, 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // 비율 기반 크기 조정
    final calendarHeight = screenHeight * 0.39; // 캘린더 높이 비율
    final diaryPreviewHeight = screenHeight * 0.25; // 미리보기 높이 비율

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(52),
        child: CalenderAppBar(),
      ),
      body: Column(
        children: [
          // 연도와 월을 선택하는 Dropdown 메뉴
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // 연도 선택 DropdownButton
                DropdownButton<int>(
                  style: const TextStyle(
                      color: AppColors.cappuccino2,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  value: selectedYear,
                  items: years.map((year) {
                    return DropdownMenuItem(
                      value: year,
                      child: Text('$year년'),
                    );
                  }).toList(),
                  onChanged: _onYearChanged,
                ),
                const SizedBox(width: 10),

                // 월 선택 DropdownButton
                DropdownButton<int>(
                  style: const TextStyle(
                      color: AppColors.cappuccino2,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  value: selectedMonth,
                  items: months.map((month) {
                    return DropdownMenuItem(
                      value: month,
                      child: Text('$month월'),
                    );
                  }).toList(),
                  onChanged: _onMonthChanged,
                ),
              ],
            ),
          ),

          // 요일 표시 Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: customWeekdays.asMap().entries.map((entry) {
              int index = entry.key;
              String day = entry.value;

              return Flexible(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: (index == 5 || index == 6)
                        ? Colors.red.withOpacity(0.1) // 주말 배경색
                        : Colors.blue.withOpacity(0.1), // 평일 배경색
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(
                    day,
                    style: TextStyle(
                      color: (index == 5 || index == 6)
                          ? Colors.red
                          : Colors.blue, // 주말 텍스트 색상
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.05,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          // 캘린더 영역
          Container(
            height: calendarHeight,
            color: Colors.grey[100],
            child: TableCalendar(
              locale: 'ko_KR',
              firstDay: DateTime.utc(2000),
              lastDay: DateTime.utc(2030),
              rowHeight: 62,
              focusedDay: focusedDay,
              calendarFormat: CalendarFormat.month,
              headerVisible: false,
              daysOfWeekHeight: 0,
              onPageChanged: (newFocusedDay) {
                setState(() {
                  focusedDay = newFocusedDay;
                  selectedYear = newFocusedDay.year;
                  selectedMonth = newFocusedDay.month;
                });
              },
              selectedDayPredicate: (day) {
                return isSameDay(selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  this.selectedDay = selectedDay;
                  this.focusedDay = focusedDay;
                });
              },
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  final diaryEntry = getDiaryEntry(day);
                  return Container(
                    width: 66,
                    height: 66,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (diaryEntry != null)
                          Image.asset(
                            height: 30,
                            diaryEntry['image']!,
                            fit: BoxFit.cover,
                          ),
                        Text(
                          '${day.day}',
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple),
                        ),
                      ],
                    ),
                  );
                },
                todayBuilder: (context, day, focusedDay) {
                  final diaryEntry = getDiaryEntry(day);
                  return Container(
                    width: 66,
                    height: 66,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (diaryEntry != null)
                          Image.asset(
                            height: 30,
                            diaryEntry['image']!,
                            fit: BoxFit.cover,
                          ),
                        Text(
                          '${day.day}',
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple),
                        ),
                      ],
                    ),
                  );
                },
                selectedBuilder: (context, day, focusedDay) {
                  final diaryEntry = getDiaryEntry(day);
                  return Container(
                    width: 66,
                    height: 66,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.rectangle, // 사각형 모양
                      border: Border.all(color: Colors.purpleAccent, width: 5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (diaryEntry != null)
                          Image.asset(
                            height: 30,
                            diaryEntry['image']!,
                            fit: BoxFit.cover,
                          ),
                        Text(
                          '${day.day}',
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          // 일기 미리보기 영역
          Container(
            height: diaryPreviewHeight,
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (getDiaryEntry(selectedDay) != null) ...[
                      Text(
                        getDiaryEntry(selectedDay)!['text'] ?? '작성된 일기가 없습니다',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Image.asset(
                        getDiaryEntry(selectedDay)!['image'] ??
                            'assets/images/default.jpg',
                        fit: BoxFit.cover,
                      ),
                    ] else
                      const Text(
                        '작성된 일기가 없습니다',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
