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
  DateTime selectedDay = DateTime.now();
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  bool isExpanded = false;
  final List<String> customWeekdays = ['일', '월', '화', '수', '목', '금', '토'];

  Map<DateTime, Map<String, dynamic>> diaryEntries = {
    DateTime(2025, 1, 1): {
      'text': '일기 제목: 오늘은 날씨가 맑았다.',
      'image': 'assets/images/sunny.jpg',
      'content': '새해 첫날, 아침부터 창문 밖으로 따뜻한 햇살이 비쳤다. 겨울인데도 불구하고 맑은 하늘이 나를 반갑게 맞이해주었다. 날씨가 너무 좋아서 집에만 있기 아까워 근처 공원으로 산책을 나갔다. '
          '공원에서는 많은 사람들이 새해를 맞아 운동을 하거나 가족들과 시간을 보내고 있었다. 아이들은 연을 날리며 웃음소리를 가득 채우고, 어르신들은 벤치에 앉아 담소를 나누고 계셨다. 이런 평화로운 광경을 보니 나도 새해의 시작을 잘 준비해야겠다는 다짐이 들었다.'
          '산책을 마치고 집으로 돌아와 따뜻한 차 한 잔과 함께 새해 계획을 정리했다. 올해는 더 건강하게, 더 긍정적으로 살아가기로 마음먹었다. 맑은 날씨가 이런 좋은 결심을 도와준 것 같다.'
          '맑은 하늘을 보며 기분 좋게 하루를 시작할 수 있어서 감사한 하루였다.',
    },
    DateTime(2025, 1, 2): {
      'text': '일기 제목: 강아지와 산책을 다녀왔다.',
      'image': 'assets/images/walkdog.jpeg',
      'content': '오늘은 날씨가 맑고 따뜻해서 강아지와 함께 산책을 다녀왔다...'
    },
  };

  Map<String, dynamic>? getDiaryEntry(DateTime day) {
    return diaryEntries[DateTime(day.year, day.month, day.day)];
  }

  List<int> years = List<int>.generate(11, (i) => 2020 + i);
  List<int> months = List<int>.generate(12, (i) => i + 1);

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

  void _toggleExpand() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final calendarHeight = screenHeight * 0.39;

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(52),
        child: CalenderAppBar(),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
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
                            ? Colors.red.withOpacity(0.1)
                            : Colors.blue.withOpacity(0.1),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text(
                        day,
                        style: TextStyle(
                          color: (index == 5 || index == 6)
                              ? Colors.red
                              : Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.05,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
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
                          shape: BoxShape.rectangle,
                          border:
                              Border.all(color: Colors.purpleAccent, width: 5),
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
            ],
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            top: isExpanded ? 0 : calendarHeight + 100,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
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
                      if (isExpanded) ...[
                        const SizedBox(height: 10),
                        Text(
                          getDiaryEntry(selectedDay)!['content'] ?? '',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ] else
                      const Text(
                        '작성된 일기가 없습니다',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: isExpanded ? 10 : calendarHeight + 90,
            left: 0,
            right: 0,
            child: Center(
              child: IconButton(
                icon: Image.asset(
                  isExpanded
                      ? 'assets/images/gotodown.png'
                      : 'assets/images/gototop.png',
                  height: 30,
                ),
                onPressed: _toggleExpand,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
