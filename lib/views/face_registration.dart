import 'dart:io';

import 'package:example/views/dashboard.dart';
import 'package:example/controllers/registration/face_registration_cubit.dart';

import 'package:facelivenessdetection/facelivenessdetection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FaceRegistrationDetector extends StatefulWidget {
  const FaceRegistrationDetector({super.key});

  @override
  State<FaceRegistrationDetector> createState() =>
      _FaceRegistrationDetectorState();
}

class _FaceRegistrationDetectorState extends State<FaceRegistrationDetector> {
  final List<Rulesets> _completedRuleset = [];
  final TextStyle _textStyle = const TextStyle();
  final _textController = TextEditingController();
  final List<File> images = [];
  final keyboardNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FaceRegistrationCubit(),
      child: Scaffold(
        // appBar: AppBar(),
        body: BlocConsumer<FaceRegistrationCubit, FaceRegistrationState>(
          listener: (context, state) {
            if (state is FaceRegistrationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          state.registrationData['message'] ??
                              'Operation completed',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: Colors.white,
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 6,
                  duration: const Duration(seconds: 3),
                ),
              );

              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => DashboardView(),
                  ),
                  (_) => false);
            } else if (state is FaceRegistrationFailed) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          state.error,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: Colors.white,
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 6,
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: FaceDetectorView(
                  ruleset: [
                    // Rulesets.blink,
                    Rulesets.smiling,
                  ],
                  dotRadius: 2.5,
                  totalDots: 70,
                  activeProgressColor: Colors.green,
                  progressColor: Colors.red,
                  // ruleset: [Rulesets.smiling],
                  backgroundColor: Theme.of(context).colorScheme.background,
                  pauseDurationInSeconds: 3,
                  cameraSize: Size(250, 250),
                  onValidationDone: (controller, trackingId) {
                    return Column(
                      children: [
                        TextField(
                          focusNode: keyboardNode,
                          controller: _textController,
                          decoration: InputDecoration(labelText: 'Name'),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        images.isNotEmpty
                            ? ElevatedButton(
                                onPressed: state is FaceRegistrationInProgress
                                    ? null
                                    : () async {
                                        keyboardNode.unfocus();

                                        context
                                            .read<FaceRegistrationCubit>()
                                            .register(
                                                images: images,
                                                name: _textController.text);
                                      },
                                child: state is FaceRegistrationInProgress
                                    ? CupertinoActivityIndicator()
                                    : Text('Next'))
                            : SizedBox(),
                      ],
                    );
                  },
                  child: (
                          {required countdown,
                          required state,
                          required hasFace,
                          required multipleFacesFound}) =>
                      Column(
                        children: [
                          multipleFacesFound
                              ? Text('Multiple faced found !!')
                              : SizedBox(),
                          SizedBox(
                            height: 20,
                          ),
                          // hasFace ? Text('Please center your face') : SizedBox(),
                          const SizedBox(height: 20),
                          multipleFacesFound
                              ? SizedBox()
                              : Row(
                                  spacing: 10,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                      Flexible(
                                          child: AnimatedSize(
                                              duration: const Duration(
                                                  milliseconds: 150),
                                              child: Text(
                                                hasFace
                                                    ? 'User face found'
                                                    : 'User face not found',
                                                style: _textStyle.copyWith(
                                                    //  color: Colors.black,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12),
                                              )))
                                    ]),
                          const SizedBox(height: 30),
                          Text(getHintText(state),
                              style: _textStyle.copyWith(
                                  //   color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20)),
                          if (countdown > 0)
                            Text.rich(
                              textAlign: TextAlign.center,
                              TextSpan(children: [
                                const TextSpan(text: 'IN'),
                                const TextSpan(text: '\n'),
                                TextSpan(
                                    text: countdown.toString(),
                                    style: _textStyle.copyWith(
                                        //   color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 22))
                              ]),
                              style: _textStyle.copyWith(
                                  //     color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),
                            )
                          else ...[
                            const SizedBox(height: 50),
                            const CupertinoActivityIndicator()
                          ]
                        ],
                      ),
                  onRulesetCompleted: (ruleset, controller) async {
                    if (!_completedRuleset.contains(ruleset)) {
                      _completedRuleset.add(ruleset);
                      //  controller?.pausePreview();
                      final image = await controller?.takePicture();
                      if (image != null) {
                        setState(() {
                          images.add(File(image.path));
                        });
                      }
                    }
                  }),
            );
          },
        ),
      ),
    );
  }
}

String getHintText(Rulesets state) {
  String hint_ = '';
  switch (state) {
    case Rulesets.smiling:
      hint_ = 'Please Smile';
      break;
    case Rulesets.blink:
      hint_ = 'Please Blink';
      break;
    case Rulesets.tiltUp:
      hint_ = 'Please Look Up';
      break;
    case Rulesets.tiltDown:
      hint_ = 'Please Look Down';
      break;
    case Rulesets.toLeft:
      hint_ = 'Please Look Left';
      break;
    case Rulesets.toRight:
      hint_ = 'Please Look Right';
      break;
  }
  return hint_;
}
