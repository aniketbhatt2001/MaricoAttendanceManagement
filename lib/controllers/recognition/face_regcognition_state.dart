part of 'face_recognition_cubit.dart';

@immutable
sealed class FaceRecognitionState {}

final class FaceRecognitionInitial extends FaceRecognitionState {}

final class FaceRecognitionInProgress extends FaceRecognitionState {}

final class FaceRecognitionSuccess extends FaceRecognitionState {
  final Map recognitionData;

  FaceRecognitionSuccess({required this.recognitionData});
}

final class FaceRecognitionFailed extends FaceRecognitionState {
  final String error;

  FaceRecognitionFailed(this.error);
}
