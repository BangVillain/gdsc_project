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

  // 샘플 일기 데이터 (날짜별)
  Map<DateTime, Map<String, dynamic>> diaryEntries = {
    DateTime(2024, 11, 1): {
      'text': '일기 제목: 오늘은 날씨가 맑았다.',
      'image': 'assets/images/sunny.jpg', // 이미지 경로 예시
    },
    DateTime(2024, 11, 2): {
      'text': '일기 제목: 강아지와 산책을 다녀왔다.',
      'image': 'assets/images/walkdog.jpeg',
    },
    // 더 많은 일기 내용을 추가
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
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(52), child: CalenderAppBar()),
      body: Column(
        children: [
          // 연도와 월을 선택하는 Dropdown 메뉴
          Padding(
            padding: const EdgeInsets.all(40),
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
          Padding(
            padding: const EdgeInsets.all(20),
            child: TableCalendar(
              locale: 'ko_KR',
              firstDay: DateTime.utc(2000),
              lastDay: DateTime.utc(2030),
              focusedDay: focusedDay,
              calendarFormat: CalendarFormat.month,
              headerVisible: false,
              onPageChanged: (newFocusedDay) {
                setState(() {
                  focusedDay = newFocusedDay;
                  selectedYear = newFocusedDay.year;
                  selectedMonth = newFocusedDay.month;
                });
              },
              selectedDayPredicate: (day) {
                // 선택된 날짜를 기준으로 스타일 적용
                return isSameDay(selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  this.selectedDay = selectedDay; // 선택된 날짜 업데이트
                  this.focusedDay = focusedDay;
                });
              },
              calendarStyle: CalendarStyle(
                defaultDecoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(6.0),
                ),
                weekendDecoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(6.0),
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(6.0),
                ),
                // 오늘 날짜의 기본 스타일 제거
                selectedDecoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.rectangle, // 사각형 모양
                  border: Border.all(color: Colors.purpleAccent, width: 5),
                ),
                defaultTextStyle: const TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                weekendTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.purple,
                ), // 기본 텍스트 스타일
                todayTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.purple,
                ),
                selectedTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.purple), // 선택한 날짜 텍스트 스타일
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekendStyle: const TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold), // 주말 색상
                weekdayStyle: const TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold), // 평일 색상
              ),
            ),
          ),
          // 선택된 날짜의 일기 미리보기 위젯
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (getDiaryEntry(selectedDay) != null) ...[
                    Text(
                      getDiaryEntry(selectedDay)!['text'] ?? '일기 없음',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Image.asset(
                      getDiaryEntry(selectedDay)!['image'] ??
                          'assets/images/default.jpg',
                      fit: BoxFit.cover,
                      height: 200,
                    ),
                  ] else
                    Text('일기 없음', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
