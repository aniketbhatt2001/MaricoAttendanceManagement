import 'dart:developer';

import 'package:example/services/attendance_service.dart';
import 'package:example/services/dio_service.dart';
import 'package:example/services/face_service.dart';
import 'package:example/views/dashboard.dart';
import 'package:example/views/face_recognizer.dart';
import 'package:example/views/face_registration.dart';
import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';

class StartRegistrationScreen extends StatefulWidget {
  const StartRegistrationScreen({super.key});

  @override
  State<StartRegistrationScreen> createState() =>
      _StartRegistrationScreenState();
}

class _StartRegistrationScreenState extends State<StartRegistrationScreen> {
  final getIt = GetIt.instance;

  void setupDependencies() async {
    log('setupDependencies..............');
    await getIt.reset();
    // getIt.registerSingleton<DioService>(DioService());
    getIt.registerSingleton<AttendanceService>(AttendanceService());
    getIt.registerSingleton<FaceService>(FaceService());
  }

  @override
  void initState() {
    super.initState();
    setupDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register your face'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Instructional text
              const Text(
                'Follow the instructions to\nregister your face',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Make sure your face is clearly visible and well-lit. Avoid wearing hats or sunglasses.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 12),
              // Avatar / face frame illustration
              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 3 / 4,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(16),
                        image: const DecorationImage(
                          image: AssetImage('assets/face_illustration.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Start Registration Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FaceRegistrationDetector(),
                      ),
                    );
                  },
                  child: const Text('Start Registration'),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => FaceRecognitionDetector(
                        onRecognized: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => DashboardView()),
                              (_) => false);
                        },
                      ),
                    ));
                  },
                  child: const Text('Start Recognition'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
