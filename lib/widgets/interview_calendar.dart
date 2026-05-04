import 'package:finalexam_salaries/model/save_jobs.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class InterviewCalendarWidget extends StatefulWidget {
  const InterviewCalendarWidget({super.key});

  @override
  State<InterviewCalendarWidget> createState() =>
      _InterviewCalendarWidgetState();
}

class _InterviewCalendarWidgetState extends State<InterviewCalendarWidget> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  void _onServiceChanged() => setState(() {});

  List<DateTime> get _interviewDates => SaveJobs.instance.interviewDates;

  List<DateTime> _getInterviewsByDay(DateTime day) {
    return _interviewDates.where((d) => isSameDay(d, day)).toList();
  }

  @override
  void initState() {
    super.initState();
    SaveJobs.instance.addListener(_onServiceChanged);
  }

  @override
  void dispose() {
    SaveJobs.instance.removeListener(_onServiceChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: colorScheme.onSurface.withValues(alpha: 0.5),
            blurRadius: 4,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2035, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: CalendarFormat.month,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });

          final hasInterview = _getInterviewsByDay(selectedDay).isNotEmpty;

          if (hasInterview) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "You have an interview on ${selectedDay.month}/${selectedDay.day}/${selectedDay.year}",
                ), //this will probably change on final polish
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
                      ? Border.all(color: colorScheme.onSurface, width: 1)
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
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
          defaultTextStyle: TextStyle(color: colorScheme.onSurface),
          weekendTextStyle: TextStyle(color: colorScheme.onSurface),
          outsideTextStyle: TextStyle(
            color: colorScheme.onSurface.withValues(alpha: 0.4),
          ),
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
            color: colorScheme.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          leftChevronIcon: Icon(
            Icons.chevron_left,
            color: colorScheme.onSurface,
          ),
          rightChevronIcon: Icon(
            Icons.chevron_right,
            color: colorScheme.onSurface,
          ),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
          weekendStyle: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
