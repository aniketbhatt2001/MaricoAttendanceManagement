part of 'attendance_history_list_cubit.dart';

@immutable
sealed class AttendanceHistoryListState {}

final class AttendanceHistoryListInitial extends AttendanceHistoryListState {}

final class AttendanceHistoryListLoading extends AttendanceHistoryListState {}

final class AttendanceHistoryLoaded extends AttendanceHistoryListState {
  final Map<String, List<Map<String, dynamic>>> attenadanceHistory;

  AttendanceHistoryLoaded(this.attenadanceHistory);
}

final class AttendanceHistoryErrorLoading extends AttendanceHistoryListState {
  final String error;

  AttendanceHistoryErrorLoading(this.error);
}
