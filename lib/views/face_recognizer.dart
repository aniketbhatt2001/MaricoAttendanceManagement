import 'package:example/controllers/recognition/face_recognition_cubit.dart';
import 'package:facelivenessdetection/facelivenessdetection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';

class FaceRecognitionDetector extends StatefulWidget {
  final VoidCallback onRecognized;
  const FaceRecognitionDetector({super.key, required this.onRecognized});

  @override
  State<FaceRecognitionDetector> createState() =>
      _FaceRecognitionDetectorState();
}

class _FaceRecognitionDetectorState extends State<FaceRecognitionDetector> {
  final List<Rulesets> _completedRuleset = [];
  final TextStyle _textStyle = const TextStyle();
  final List<File> images = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FaceRecognitionCubit(),
      child: Builder(builder: (context) {
        return Scaffold(
          body: BlocConsumer<FaceRecognitionCubit, FaceRecognitionState>(
            listener: (context, state) {
              if (state is FaceRecognitionSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            state.recognitionData['message'] ??
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

                widget.onRecognized();
              } else if (state is FaceRecognitionFailed) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            state.error ?? 'Operation completed',
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

                Navigator.of(context).pop();
              }
            },
            builder: (context, state) {
              return SafeArea(
                child: FaceDetectorView(
                    ruleset: [
                      //      Rulesets.blink,
                      Rulesets.smiling,
                    ],
                    dotRadius: 2.5,
                    totalDots: 70,
                    activeProgressColor: Colors.green,
                    progressColor: Colors.red,
                    backgroundColor: Theme.of(context).colorScheme.background,
                    pauseDurationInSeconds: 3,
                    cameraSize: Size(250, 250),
                    onValidationDone: (controller, trackingId) {
                      return images.isNotEmpty
                          ? ElevatedButton(
                              onPressed: state is FaceRecognitionInProgress
                                  ? null
                                  : () async {
                                      context
                                          .read<FaceRecognitionCubit>()
                                          .recognize(
                                            images: images,
                                          );
                                    },
                              child: state is FaceRecognitionInProgress
                                  ? CupertinoActivityIndicator()
                                  : Text('Next'))
                          : SizedBox();
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
                            const SizedBox(height: 20),
                            multipleFacesFound
                                ? SizedBox()
                                : Row(
                                    spacing: 10,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 12),
                                                )))
                                      ]),
                            const SizedBox(height: 30),
                            Text(getHintText(state),
                                style: _textStyle.copyWith(
                                    fontWeight: FontWeight.w600, fontSize: 20)),
                            if (countdown > 0)
                              Text.rich(
                                textAlign: TextAlign.center,
                                TextSpan(children: [
                                  const TextSpan(text: 'IN'),
                                  const TextSpan(text: '\n'),
                                  TextSpan(
                                      text: countdown.toString(),
                                      style: _textStyle.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 22))
                                ]),
                                style: _textStyle.copyWith(
                                    fontWeight: FontWeight.w600, fontSize: 16),
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
                        // await controller?.pausePreview();
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
        );
      }),
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
