import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:example/main.dart';
import 'package:example/services/attendance_service.dart';
import 'package:example/services/face_service.dart';
import 'package:meta/meta.dart';

part 'face_registration_state.dart';

class FaceRegistrationCubit extends Cubit<FaceRegistrationState> {
  FaceRegistrationCubit() : super(FaceRegistrationInitial());

  Future<void> register(
      {required List<File> images, required String name}) async {
    try {
      if (name.trim().isEmpty) {
        return;
      }
      emit(FaceRegistrationInProgress());
      final livenessResult = await FaceService.checkLiveness(images: images);
      log('livenessResult $livenessResult');
      if (livenessResult['face_state']['result'].toString().toLowerCase() ==
          'real') {
        final res = await FaceService.registerFace(images: images, name: name);
        await getIt.get<AttendanceService>().registerEmployee(
            qdrantId: res['qdrant_id'].toString(), name: name);
        emit(FaceRegistrationSuccess(registrationData: res));
      } else {
        emit(FaceRegistrationFailed('Liveness failed'));
      }
    } catch (e) {
      emit(FaceRegistrationFailed(e.toString()));
    }
  }
}
