import 'package:example/controllers/employee/employee_attendance_cubit.dart';
import 'package:example/services/time_stamp_formater_service.dart';
import 'package:example/views/face_recognizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({
    super.key,
  });

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final mq = MediaQuery.of(context);
    final vPad = mq.size.height * 0.02;

    return Builder(builder: (context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today',
            style: TextStyle(
              color: cs.onBackground,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          const SizedBox(height: 24),
          Text(
            'Attendance',
            style: TextStyle(
              color: cs.onBackground,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          BlocBuilder<EmployeeAttendanceCubit, EmployeeAttendanceState>(
            builder: (context, state) {
              if (state is EmployeeAttendanceLoaded &&
                  state.currentDate != null) {
                final currentData = state.currentDate;
                final checkInTime = currentData!['checkIn']
                    ? formatTimestamp(currentData['checkInTime'])
                    : '';
                final checkOuTime = currentData['checkOut']
                    ? formatTimestamp(currentData['checkOutTime'])
                    : '';
                return Column(
                  children: [
                    currentData['checkIn']
                        ? _buildRecordRow(checkInTime, 'Entry', cs)
                        : SizedBox(),
                    const SizedBox(height: 16),
                    currentData['checkOut']
                        ? _buildRecordRow(checkOuTime, 'Exit', cs)
                        : SizedBox(),
                  ],
                );
              }

              return SizedBox();
            },
          ),
          const SizedBox(height: 24),
          BlocBuilder<EmployeeAttendanceCubit, EmployeeAttendanceState>(
              builder: (context, state) {
            return SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.primary,
                  foregroundColor: cs.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: (state is EmployeeAttendanceLoaded &&
                        state.currentDate != null &&
                        state.currentDate!['checkOut'] == true)
                    ? null
                    : () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => FaceRecognitionDetector(
                            onRecognized: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ));
                      },
                child: const Text(
                  'Mark Attendance',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }),
          SizedBox(height: vPad),
        ],
      );
    });
  }

  Widget _buildRecordRow(String time, String label, ColorScheme colorScheme) {
    final cs = colorScheme;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.access_time,
            color: cs.onSurface,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                time,
                style: TextStyle(
                  color: cs.onBackground,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  color: cs.onSurface.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
