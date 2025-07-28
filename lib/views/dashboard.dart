import 'package:example/controllers/attendanceHistoryList/attendance_history_list_cubit.dart';
import 'package:example/controllers/employee/employee_attendance_cubit.dart';
import 'package:example/registration.dart';

import 'package:example/views/home_content.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _currentIndex = 0;

  final List<Widget> _dashBoardOptions = const [
    HomeContent(),
    Text('Attendance History'),
    Text("Employees"),
    Text("Settings"),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final mq = MediaQuery.of(context);
    final hPad = mq.size.width * 0.05;
    final vPad = mq.size.height * 0.02;

    return PopScope(
      canPop: false,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => EmployeeAttendanceCubit(),
          ),
        ],
        child: Builder(builder: (context) {
          return Scaffold(
            backgroundColor: cs.background,
            appBar: AppBar(
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => StartRegistrationScreen(),
                          ),
                          (_) => false);
                    },
                    icon: Icon(Icons.logout))
              ],
              automaticallyImplyLeading: false,
              backgroundColor: cs.background,
              elevation: 0,
              centerTitle: true,
              title: const Text('Attendance'),
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: cs.surface,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: cs.primary,
              unselectedItemColor: cs.onSurface.withOpacity(0.7),
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_month_outlined),
                  activeIcon: Icon(Icons.calendar_month_sharp),
                  label: 'Attendance',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.people_outline),
                  activeIcon: Icon(Icons.people_sharp),
                  label: 'Employees',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings_outlined),
                  activeIcon: Icon(Icons.settings_sharp),
                  label: 'Settings',
                ),
              ],
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
              child: _dashBoardOptions[_currentIndex],
            ),
          );
        }),
      ),
    );
  }
}
