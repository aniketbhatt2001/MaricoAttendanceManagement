part of 'face_registration_cubit.dart';

@immutable
sealed class FaceRegistrationState {}

final class FaceRegistrationInitial extends FaceRegistrationState {}

final class FaceRegistrationInProgress extends FaceRegistrationState {}

final class FaceRegistrationSuccess extends FaceRegistrationState {
  final Map registrationData;

  FaceRegistrationSuccess({required this.registrationData});
}

final class FaceRegistrationFailed extends FaceRegistrationState {
  final String error;

  FaceRegistrationFailed(this.error);
}
