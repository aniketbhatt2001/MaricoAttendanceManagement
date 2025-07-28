import 'package:example/controllers/attendanceHistoryList/attendance_history_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttendanceHistoryListCubit, AttendanceHistoryListState>(
      builder: (context, state) {
        return Scaffold();
      },
    );
  }
}
