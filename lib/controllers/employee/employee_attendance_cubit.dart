import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:example/main.dart';
import 'package:example/services/attendance_service.dart';

part 'employee_attendance_state.dart';

// lib/cubit/employee_attendance_cubit.dart

class EmployeeAttendanceCubit extends Cubit<EmployeeAttendanceState> {
  late final StreamSubscription<int> _qdrantSub;

  EmployeeAttendanceCubit() : super(EmployeeAttendanceInitial()) {
    final sessionQdrantId = getIt.get<AttendanceService>().sessionQdrantId;
    if (sessionQdrantId != null) {
      getCurrentDateEmployeeAttendance(sessionQdrantId.toString());
    }
    _qdrantSub = getIt.get<AttendanceService>().qdrantIdStream.listen(
      (id) => getCurrentDateEmployeeAttendance(id.toString()),
      onError: (err, stk) {
        emit(EmployeeAttendanceError("Stream error: ${err.toString()}"));
      },
    );
  }

  Future<void> getCurrentDateEmployeeAttendance(String qdrantId) async {
    try {
      emit(EmployeeAttendanceLoading());

      final currentDate = await getIt
          .get<AttendanceService>()
          .getCurrentDateEmployeeAttendance(qdrantId);

      emit(EmployeeAttendanceLoaded(currentDate: currentDate));
    } catch (error, stack) {
      final message = (error is Exception)
          ? error.toString().replaceFirst('Exception: ', '')
          : "Unexpected error";
      emit(EmployeeAttendanceError(message));
      // optionally log stack for debugging
    }
  }

  @override
  Future<void> close() {
    _qdrantSub.cancel();

    return super.close();
  }
}
