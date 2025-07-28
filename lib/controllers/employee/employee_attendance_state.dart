part of 'employee_attendance_cubit.dart';

// ─── STATE CLASSES ────────────────────────────────────────────────────────────
abstract class EmployeeAttendanceState {}

class EmployeeAttendanceInitial extends EmployeeAttendanceState {}

class EmployeeAttendanceLoading extends EmployeeAttendanceState {}

class EmployeeAttendanceLoaded extends EmployeeAttendanceState {
  final Map<String, dynamic>? currentDate;
  EmployeeAttendanceLoaded({this.currentDate});
}

// class EmployeeCurrentDateAttendanceLoaded extends EmployeeAttendanceState {
//   final Map<String, dynamic>? attendance;
//   EmployeeCurrentDateAttendanceLoaded(this.attendance);
// }

class EmployeeAttendanceError extends EmployeeAttendanceState {
  final Object error;
  EmployeeAttendanceError(this.error);
}
