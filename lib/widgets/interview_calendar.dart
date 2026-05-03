import 'package:finalexam_salaries/model/save_jobs.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';


class InterviewCalendarWidget extends StatefulWidget {
  const InterviewCalendarWidget({super.key});

  @override
  State<InterviewCalendarWidget> createState() => _InterviewCalendarWidgetState();
}

class _InterviewCalendarWidgetState extends State<InterviewCalendarWidget> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<DateTime> get _interviewDates => SaveJobs.instance.interviewDates;

  List<DateTime> _getInterviewsByDay(DateTime day) {
    return _interviewDates
        .where((d) => isSameDay(d, day))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(4),
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2035, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: CalendarFormat.month,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay){
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });

          final hasInterview = _getInterviewsByDay(selectedDay).isNotEmpty;

          if(hasInterview) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("You have an interview of ${selectedDay.month}/${selectedDay.day}/${selectedDay.year}"), //this will probably change on final polish
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        eventLoader: _getInterviewsByDay,
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, day, events) {
            if (events.isEmpty) return null;

            return Positioned(
              bottom: 8,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: colorScheme.secondary.withValues(alpha: 0.5),
                  border: isSameDay(day, DateTime.now())
                      ? Border.all(color: colorScheme.onPrimary, width: 1)
                      : null,
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        ),
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            border: Border.all(color: Colors.transparent),
          ),
          todayTextStyle: TextStyle(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
          defaultTextStyle: TextStyle(color: colorScheme.onPrimary),
          weekendTextStyle: TextStyle(color: colorScheme.onPrimary),
          outsideTextStyle: TextStyle( color: colorScheme.onPrimary.withValues(alpha: 0.4),),
          selectedDecoration: BoxDecoration(
            color: colorScheme.secondary.withValues(alpha: 0.4),
            shape: BoxShape.circle,
          ),
          markersMaxCount: 1,
          markerSize: 0,
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(
            color: colorScheme.onPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          leftChevronIcon: Icon(Icons.chevron_left, color: colorScheme.onPrimary),
          rightChevronIcon: Icon(Icons.chevron_right, color: colorScheme.onPrimary),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
          weekendStyle: TextStyle(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
