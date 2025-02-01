import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
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
  Map<String, Map<String, dynamic>> diaryEntries = {};

  @override
  void initState() {
    super.initState();
    _fetchDiaryEntries();
  }

  Future<void> _fetchDiaryEntries() async {
    final url = Uri.parse('http://52.79.42.44:8080/getdiary');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decodedResponse = utf8.decode(response.bodyBytes);
        final data = jsonDecode(decodedResponse);
        await _processDiaryEntries(data['diary']);
        print(diaryEntries);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _processDiaryEntries(List<dynamic> entries) async {
    for (var entry in entries) {
      DateTime date = DateTime.parse(entry['date']);
      String formattedDate = DateFormat('yyyy-MM-dd').format(date);
      String imagePath = entry['sticker_path'];
      final url2 = Uri.parse('http://52.79.42.44:8080/getimage?sticker_path=$imagePath');
      final res2 = await http.get(url2);

      if (res2.statusCode == 200) {
        final decodedResponse2 = utf8.decode(res2.bodyBytes);
        final data2 = jsonDecode(decodedResponse2);
        final base64Decoded = base64Decode(data2['image']);
        setState(() {
          diaryEntries[formattedDate] = {
            'title': entry['title'],
            'content': entry['content'],
            'image': Image.memory(base64Decoded),
          };
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final calendarHeight = screenHeight * 0.39;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Calendar'),
      ),
      body: GestureDetector(
        onTap: () {
          setState(() {
            isExpanded = !isExpanded;
          });
        },
        onPanUpdate: (details) {
          if (details.delta.dy < -10) {
            setState(() {
              isExpanded = true;
            });
          } else if (details.delta.dy > 10) {
            setState(() {
              isExpanded = false;
            });
          }
        },
        onPanEnd: (details) {
          if (details.velocity.pixelsPerSecond.dy < 0) {
            setState(() {
              isExpanded = true;
            });
          } else if (details.velocity.pixelsPerSecond.dy > 0) {
            setState(() {
              isExpanded = false;
            });
          }
        },
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      DropdownButton<int>(
                        style: const TextStyle(
                            color: AppColors.cappuccino2,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        value: selectedYear,
                        items: List<int>.generate(11, (i) => 2020 + i).map((year) {
                          return DropdownMenuItem(
                            value: year,
                            child: Text('$year년'),
                          );
                        }).toList(),
                        onChanged: (year) {
                          setState(() {
                            selectedYear = year!;
                            focusedDay = DateTime(selectedYear, selectedMonth, 1);
                          });
                        },
                      ),
                      const SizedBox(width: 10),
                      DropdownButton<int>(
                        style: const TextStyle(
                            color: AppColors.cappuccino2,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        value: selectedMonth,
                        items: List<int>.generate(12, (i) => i + 1).map((month) {
                          return DropdownMenuItem(
                            value: month,
                            child: Text('$month월'),
                          );
                        }).toList(),
                        onChanged: (month) {
                          setState(() {
                            selectedMonth = month!;
                            focusedDay = DateTime(selectedYear, selectedMonth, 1);
                          });
                        },
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
                    firstDay: DateTime.utc(2024),
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
                        final formattedDate = DateFormat('yyyy-MM-dd').format(day);
                        final diaryEntry = diaryEntries[formattedDate];
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
                                diaryEntry['image'],
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
                        final formattedDate = DateFormat('yyyy-MM-dd').format(day);
                        final diaryEntry = diaryEntries[formattedDate];
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
                                diaryEntry['image'],
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
                        final formattedDate = DateFormat('yyyy-MM-dd').format(day);
                        final diaryEntry = diaryEntries[formattedDate];
                        return Container(
                          width: 66,
                          height: 66,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            shape: BoxShape.rectangle,
                            border: Border.all(
                                color: Colors.purpleAccent, width: 5),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (diaryEntry != null)
                                diaryEntry['image'],
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
                child: isExpanded
                    ? SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (diaryEntries[DateFormat('yyyy-MM-dd').format(selectedDay)] != null) ...[
                              Text(
                                diaryEntries[DateFormat('yyyy-MM-dd').format(selectedDay)]!['title'] ??
                                    '작성된 일기가 없습니다',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              diaryEntries[DateFormat('yyyy-MM-dd').format(selectedDay)]!['image'],
                              const SizedBox(height: 10),
                              Text(
                                diaryEntries[DateFormat('yyyy-MM-dd').format(selectedDay)]!['content'] ?? '',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ] else
                              const Text(
                                '작성된 일기가 없습니다',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (diaryEntries[DateFormat('yyyy-MM-dd').format(selectedDay)] != null) ...[
                            Text(
                              diaryEntries[DateFormat('yyyy-MM-dd').format(selectedDay)]!['title'] ??
                                  '작성된 일기가 없습니다',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            diaryEntries[DateFormat('yyyy-MM-dd').format(selectedDay)]!['image'],
                            const SizedBox(height: 10),
                            Text(
                              diaryEntries[DateFormat('yyyy-MM-dd').format(selectedDay)]!['content'] ?? '',
                              style: const TextStyle(fontSize: 16),
                            ),
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
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              top: isExpanded ? 10 : screenHeight * 0.39 + 105,
              left: 0,
              right: 0,
              child: Center(
                child: Column(
                  children: [
                    Container(
                      width: 70,
                      height: 7,
                      decoration: BoxDecoration(
                        color: Colors.grey[500],
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}