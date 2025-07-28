import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class AttendanceService {
  AttendanceService();
  //static final _instance = AttendanceService._();
  //factory AttendanceService() => _instance;
  void _unlockSession() => sessionQdrantId = null;

  final _firestore = FirebaseFirestore.instance;
  int? sessionQdrantId;
  final StreamController<int> _qdrantIdController =
      StreamController<int>.broadcast();

  Stream<int> get qdrantIdStream => _qdrantIdController.stream;
  StreamSink<int> get _sink => _qdrantIdController.sink;

  bool _validateOrSetSession(int qdrantId) {
    if (sessionQdrantId == null) {
      sessionQdrantId = qdrantId;
      return true;
    }
    return sessionQdrantId == qdrantId;
  }

  Future<bool> registerEmployee({
    required String qdrantId,
    required String name,
  }) async {
    _unlockSession();
    final docRef = _firestore.collection('employees').doc(qdrantId);
    final snapshot = await docRef.get();
    if (snapshot.exists) {
      throw Exception('User already exists');
    }
    await docRef.set({
      'name': name,
      'faceRegistered': true,
      'registrationDate': FieldValue.serverTimestamp(),
      'qdrantId': qdrantId,
    });

    return true;
  }

  Future<void> markAttendance({
    required String qdrantId,
  }) async {
    if (!_validateOrSetSession(int.parse(qdrantId))) {
      throw Exception('Session locked to another user');
    }
    final date = DateTime.now();
    final formattedDate = DateFormat('dd-MM-yyyy').format(date);
    final attendanceDocRef = _firestore
        .collection('employees')
        .doc(qdrantId)
        .collection('attendanceData')
        .doc(formattedDate);
    final snapshot = await attendanceDocRef.get();
    if (snapshot.exists) {
      final data = snapshot.data()!;
      final checkedIn = data['checkIn'] == true;
      final checkedOut = data['checkOut'] == true;
      if (!checkedIn) {
        await attendanceDocRef.update({
          'checkIn': true,
          'checkInTime': FieldValue.serverTimestamp(),
        });
      } else if (checkedIn && !checkedOut) {
        await attendanceDocRef.update({
          'checkOut': true,
          'checkOutTime': FieldValue.serverTimestamp(),
        });
      }
    } else {
      await attendanceDocRef.set({
        'qdrantId': qdrantId,
        'checkIn': true,
        'checkInTime': FieldValue.serverTimestamp(),
        'checkOut': false,
      });
    }
    _sink.add(int.parse(qdrantId));
  }

  Future<List<Map<String, dynamic>>> getAttendanceHistory(
      String qdrantId) async {
    final query = await _firestore
        .collection('employees')
        .doc(qdrantId)
        .collection('attendanceData')
        .get();
    return query.docs.map((d) => d.data()).toList();
  }

  Future<Map<String, dynamic>?> getCurrentDateEmployeeAttendance(
      String qdrantId) async {
    final today = DateFormat('dd-MM-yyyy').format(DateTime.now());
    final doc = await _firestore
        .collection('employees')
        .doc(qdrantId)
        .collection('attendanceData')
        .doc(today)
        .get();
    return doc.data();
  }

  void dispose() {
    _qdrantIdController.close();
    sessionQdrantId = null;
  }
}
