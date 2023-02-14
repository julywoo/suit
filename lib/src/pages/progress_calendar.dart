import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ProgressCalendar extends StatefulWidget {
  /// Creates the home page to display teh calendar widget.
  const ProgressCalendar({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProgressCalendarState createState() => _ProgressCalendarState();
}

class _ProgressCalendarState extends State<ProgressCalendar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: SfCalendar(
              view: CalendarView.month,
              onTap: (CalendarTapDetails details) {},
              timeZone: null,
              //allowViewNavigation: true,
              showDatePickerButton: true,
              // allowedViews: <CalendarView>[
              //   CalendarView.day,
              //   CalendarView.week,
              //   CalendarView.workWeek,
              //   CalendarView.month,
              // ],
              timeSlotViewSettings: TimeSlotViewSettings(
                  startHour: 10,
                  endHour: 20,
                  timeRulerSize: 0,
                  timeInterval: Duration(),
                  timeIntervalHeight: 0),
              scheduleViewSettings: ScheduleViewSettings(
                monthHeaderSettings: MonthHeaderSettings(height: 0),
                appointmentTextStyle: TextStyle(),
                hideEmptyScheduleWeek: true,
                appointmentItemHeight: 70,
              ),
              dataSource: MeetingDataSource(_getDataSource()),
              // by default the month appointment display mode set as Indicator, we can
              // change the display mode as appointment using the appointment display
              // mode property
              monthViewSettings: const MonthViewSettings(
                  showAgenda: true,
                  appointmentDisplayMode:
                      MonthAppointmentDisplayMode.appointment),
            ),
          ),
        ));
  }

  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now();

    final DateTime startTime = DateTime(today.year, today.month, today.day);
    final DateTime endTime = DateTime(2022, 08, 22);
    final DateTime startTime1 = DateTime(2022, 07, 31);
    final DateTime endTime1 = DateTime(2022, 08, 16);

    final DateTime startTime2 = DateTime(2022, 08, 07);
    final DateTime endTime2 = DateTime(2022, 08, 13);
    meetings.add(Meeting(
        'Conference', startTime2, endTime2, const Color(0xFF0F8644), false));

    meetings.add(Meeting(
        'Conference', startTime1, endTime1, const Color(0xFF0F8644), false));
    meetings.add(Meeting(
        'Conference', startTime, endTime, const Color(0xFF0F8644), false));
    meetings.add(Meeting(
        'Conference', startTime, endTime, const Color(0xFF0F8644), false));

    return meetings;
  }

  void calendarTapped(CalendarTapDetails details) {
    print('aaa');
  }
}

/// An object to set the appointment collection data source to calendar, which
/// used to map the custom appointment data to the calendar appointment, and
/// allows to add, remove or reset the appointment collection.
class MeetingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).eventName;
  }

  @override
  Color getColor(int index) {
    return _getMeetingData(index).background;
  }

  @override
  bool isAllDay(int index) {
    return _getMeetingData(index).isAllDay;
  }

  Meeting _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final Meeting meetingData;
    if (meeting is Meeting) {
      meetingData = meeting;
    }

    return meetingData;
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the event data which will be rendered in calendar.
class Meeting {
  /// Creates a meeting class with required details.
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  /// Event name which is equivalent to subject property of [Appointment].
  String eventName;

  /// From which is equivalent to start time property of [Appointment].
  DateTime from;

  /// To which is equivalent to end time property of [Appointment].
  DateTime to;

  /// Background which is equivalent to color property of [Appointment].
  Color background;

  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  bool isAllDay;
}
