import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:hospital_mobile_app/provider/doctorProvider.dart';
import 'package:auto_route/auto_route.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hospital_mobile_app/routes/app_router.dart';
import 'package:hospital_mobile_app/service/constant.dart';
import 'package:hospital_mobile_app/service/secure_storage.dart';
import 'package:hospital_mobile_app/service/sttServiceIPD.dart';
import 'package:hospital_mobile_app/service/sttServices.dart';
import 'package:hospital_mobile_app/theme/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;




enum VoiceOverlayState { recording, paused, analyzing }

class VoiceRecordingOverlay extends StatefulWidget {
  final VoidCallback onStop;
  final VoidCallback onCancel;
  final VoidCallback? onPause;
  final VoidCallback? onResume;
  // ← NEW: cancel while analyzing (discards result)
  final VoidCallback? onCancelAnalyzing;
  final VoiceOverlayState state;
  final String? errorMessage;

  const VoiceRecordingOverlay({
    super.key,
    required this.onStop,
    required this.onCancel,
    this.onPause,
    this.onResume,
    this.onCancelAnalyzing,
    required this.state,
    this.errorMessage,
  });

  @override
  State<VoiceRecordingOverlay> createState() => _VoiceRecordingOverlayState();
}

class _VoiceRecordingOverlayState extends State<VoiceRecordingOverlay>
    with TickerProviderStateMixin {
  late AnimationController _spinController;
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late AnimationController _progressController;
  late AnimationController _orbit1Controller;
  late AnimationController _orbit2Controller;

  late Animation<double> _pulseAnim;
  late Animation<double> _progressAnim;

  final List<bool> _stepVisible = [false, false, false, false];

  // ── Cancel confirmation during recording/paused ──
  Future<void> _showCancelConfirm() async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: const Color(0xFF0B1F5A),
        title: const Text(
          'Discard Recording?',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Your current recording will be discarded. You will return to the diagnosis form.',
          style: TextStyle(color: Colors.white70, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Keep Recording',
                style: TextStyle(color: Color(0xFF4FC3F7))),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Discard',
                style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
    if (confirmed == true) widget.onCancel();
  }


  // ── Cancel confirmation during analyzing ──
  Future<void> _showCancelAnalyzingConfirm() async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: const Color(0xFF0B1F5A),
        title: const Text(
          'Cancel Analysis?',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'The AI is currently analysing your recording. Cancelling now will discard the result and return you to the diagnosis form.',
          style: TextStyle(color: Colors.white70, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Keep Analysing',
                style: TextStyle(color: Color(0xFF4FC3F7))),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child:
                const Text('Cancel', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
    if (confirmed == true && widget.onCancelAnalyzing != null) {
      widget.onCancelAnalyzing!();
    }
  }



  @override
  void initState() {
    super.initState();

    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 45),
    )..forward();

    _orbit1Controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _orbit2Controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    _pulseAnim = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _progressAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
  CurvedAnimation(parent: _progressController, curve: Curves.easeIn),
);

    if (widget.state == VoiceOverlayState.analyzing) _revealSteps();

    if (widget.state == VoiceOverlayState.paused) _waveController.stop();
  }

  void _revealSteps() {
    final delays = [300, 1200, 2400, 3800];
    for (int i = 0; i < delays.length; i++) {
      Future.delayed(Duration(milliseconds: delays[i]), () {
        if (mounted) setState(() => _stepVisible[i] = true);
      });
    }
  }

  @override
  void didUpdateWidget(VoiceRecordingOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.state == VoiceOverlayState.analyzing &&
        oldWidget.state != VoiceOverlayState.analyzing) {
      _revealSteps();
      _progressController.forward(from: 0);
      _waveController.repeat(reverse: true);
    }

    if (widget.state == VoiceOverlayState.paused &&
        oldWidget.state == VoiceOverlayState.recording) {
      _waveController.stop();
    }

    if (widget.state == VoiceOverlayState.recording &&
        oldWidget.state == VoiceOverlayState.paused) {
      _waveController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _spinController.dispose();
    _pulseController.dispose();
    _waveController.dispose();
    _progressController.dispose();
    _orbit1Controller.dispose();
    _orbit2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAnalyzing = widget.state == VoiceOverlayState.analyzing;
    final isPaused = widget.state == VoiceOverlayState.paused;
    final isRecording = widget.state == VoiceOverlayState.recording;
    final size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        if (isAnalyzing) {
          await _showCancelAnalyzingConfirm();
        } else {
          await _showCancelConfirm();
        }
        return false;
      },
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF050E2B),
                Color(0xFF0B1F5A),
                Color(0xFF0857C0),
              ],
              stops: [0.0, 0.55, 1.0],
            ),
          ),
          child: Stack(
            children: [
              // ── Floating particles ──
              ...List.generate(10, (i) {
                final rnd = Random(i * 17);
                final sz = rnd.nextDouble() * 4 + 2.0;
                final lx = rnd.nextDouble() * size.width;
                final ty = rnd.nextDouble() * size.height;
                return AnimatedBuilder(
                  animation: _pulseController,
                  builder: (_, __) {
                    final v =
                        sin((_pulseController.value * 2 * pi) + i * 0.9);
                    return Positioned(
                      left: lx,
                      top: ty + v * 10,
                      child: Opacity(
                        opacity: 0.05 + v.abs() * 0.09,
                        child: Container(
                          width: sz,
                          height: sz,
                          decoration: const BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                        ),
                      ),
                    );
                  },
                );
              }),

              // ── Rotating orbit rings ──
              Center(
                child: AnimatedBuilder(
                  animation: _orbit1Controller,
                  builder: (_, __) => Transform.rotate(
                    angle: _orbit1Controller.value * 2 * pi,
                    child: Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: SweepGradient(colors: [
                          Colors.transparent,
                          const Color(0xFF4FC3F7)
                              .withOpacity(isPaused ? 0.15 : 0.5),
                          Colors.transparent,
                        ]),
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: AnimatedBuilder(
                  animation: _orbit2Controller,
                  builder: (_, __) => Transform.rotate(
                    angle: -_orbit2Controller.value * 2 * pi,
                    child: Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: SweepGradient(colors: [
                          Colors.transparent,
                          const Color(0xFF7C83FF).withOpacity(0.25),
                          Colors.transparent,
                        ]),
                      ),
                    ),
                  ),
                ),
              ),

              // ── Main content ──
              Column(
                children: [
                  // ── Top-right Cancel button (recording / paused) ──
                  if (!isAnalyzing)
                    SafeArea(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8, right: 12),
                          child: TextButton.icon(
                            onPressed: _showCancelConfirm,
                            icon: const Icon(Icons.close_rounded,
                                color: Colors.white70, size: 18),
                            label: const Text('Cancel',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 13)),
                          ),
                        ),
                      ),
                    ),

                  // ── Top-right Cancel button (analyzing) ──
                  if (isAnalyzing)
                    SafeArea(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8, right: 12),
                          child: TextButton.icon(
                            onPressed: _showCancelAnalyzingConfirm,
                            icon: const Icon(Icons.close_rounded,
                                color: Colors.white54, size: 18),
                            label: const Text('Cancel',
                                style: TextStyle(
                                    color: Colors.white54, fontSize: 13)),
                          ),
                        ),
                      ),
                    ),

                  const Spacer(flex: 2),

                  // ── Center icon ──
                  AnimatedBuilder(
                    animation: _pulseAnim,
                    builder: (_, __) => Transform.scale(
                      scale: isAnalyzing ? 1.0 : _pulseAnim.value,
                      child: SizedBox(
                        width: 140,
                        height: 140,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: _glowColor(isAnalyzing, isPaused)
                                        .withOpacity(0.45),
                                    blurRadius: 40,
                                    spreadRadius: 12,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _coreColor(isAnalyzing, isPaused),
                                border: Border.all(
                                  color:
                                      const Color(0xFF4FC3F7).withOpacity(0.4),
                                  width: 1.5,
                                ),
                              ),
                              child: isAnalyzing
                                  ? const Padding(
                                      padding: EdgeInsets.all(34),
                                      child: CircularProgressIndicator(
                                          color: Colors.white, strokeWidth: 2.5),
                                    )
                                  : Icon(
                                      isPaused
                                          ? Icons.pause_rounded
                                          : Icons.mic_rounded,
                                      color: Colors.white,
                                      size: 58),
                            ),
                            if (isAnalyzing)
                              AnimatedBuilder(
                                animation: _spinController,
                                builder: (_, __) => Transform.rotate(
                                  angle: _spinController.value * 2 * pi,
                                  child: SizedBox(
                                    width: 130,
                                    height: 130,
                                    child: CustomPaint(
                                      painter: _ArcPainter(
                                          color: const Color(0xFF4FC3F7)),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Sound wave (recording only) ──
                  if (isRecording)
                    AnimatedBuilder(
                      animation: _waveController,
                      builder: (_, __) => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(9, (i) {
                          final v = sin((i * 0.65) +
                              (_waveController.value * 2 * pi));
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: 5,
                            height: 12.0 + v.abs() * 30,
                            decoration: BoxDecoration(
                              color: Colors.white
                                  .withOpacity(0.5 + v.abs() * 0.5),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          );
                        }),
                      ),
                    ),

                  // ── Flat bars (paused) ──
                  if (isPaused)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(9, (i) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: 5,
                          height: 14,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        );
                      }),
                    ),

                  if (!isAnalyzing) const SizedBox(height: 28),

                  // ── Animated dots (analyzing) ──
                  if (isAnalyzing) ...[
                    const SizedBox(height: 8),
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (_, __) => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (i) {
                          final v = sin(
                              (_pulseController.value * 2 * pi) + i * 1.1);
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            width: 9,
                            height: 9,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF4FC3F7)
                                  .withOpacity(0.25 + v.abs() * 0.75),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 18),
                  ],

                  // ── Title ──
                  Text(
                    isAnalyzing
                        ? 'Analysing Prescription'
                        : isPaused
                            ? 'Recording Paused'
                            : 'Listening...',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 44),
                    child: Text(
                      isAnalyzing
                          ? 'AI is processing your voice and filling in the diagnosis details automatically'
                          : isPaused
                              ? 'Recording is paused. Resume to continue or stop to analyse what was recorded.'
                              : 'Speak clearly — mention diagnosis, medicines, dosage, food timing, and advice',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.62),
                        fontSize: 13.5,
                        height: 1.6,
                      ),
                    ),
                  ),

                  // ── Progress bar (analyzing) ──
                  if (isAnalyzing) ...[
                    const SizedBox(height: 28),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 48),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedBuilder(
                            animation: _progressAnim,
                            builder: (_, __) => ClipRRect(
                              borderRadius: BorderRadius.circular(2),
                              child: Stack(
                                children: [
                                  Container(
                                    height: 3,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  FractionallySizedBox(
                                    widthFactor: _progressAnim.value,
                                    child: Container(
                                      height: 3,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF4FC3F7),
                                            Color(0xFF7C83FF),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Processing audio',
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.35),
                                      fontSize: 11.5)),
                              AnimatedBuilder(
                                animation: _progressAnim,
                                builder: (_, __) => Text(
                                  '${(_progressAnim.value * 100).round()}%',
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.4),
                                      fontSize: 11.5),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],

                  // ── Step indicators (analyzing) ──
                  if (isAnalyzing) ...[
                    const SizedBox(height: 22),
                    ..._buildSteps(),
                  ],

                  const Spacer(flex: 2),

                  // ── Action buttons (recording / paused) ──
                  if (!isAnalyzing) ...[
                    // ── Pause / Resume button ──
                    GestureDetector(
                      onTap: isPaused ? widget.onResume : widget.onPause,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 36, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.25),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                                isPaused
                                    ? Icons.play_arrow_rounded
                                    : Icons.pause_rounded,
                                color: Colors.white,
                                size: 22),
                            const SizedBox(width: 10),
                            Text(
                              isPaused ? 'Resume Recording' : 'Pause Recording',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // ── Stop & Analyse button ──
                    GestureDetector(
                      onTap: widget.onStop,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 44, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.13),
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.35),
                            width: 1.5,
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.stop_rounded,
                                color: Colors.white, size: 22),
                            SizedBox(width: 10),
                            Text(
                              'Stop & Analyse',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 60),
                ],
              ),

              // ── Error banner ──
              if (widget.errorMessage != null)
                Positioned(
                  bottom: 80,
                  left: 24,
                  right: 24,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.withOpacity(0.4)),
                    ),
                    child: Text(
                      widget.errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.redAccent, fontSize: 13),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _glowColor(bool isAnalyzing, bool isPaused) {
    if (isAnalyzing) return const Color(0xFF4FC3F7);
    if (isPaused) return Colors.orange;
    return Colors.red;
  }

  Color _coreColor(bool isAnalyzing, bool isPaused) {
    if (isAnalyzing) return const Color(0xFF1565C0);
    if (isPaused) return Colors.orange.shade700;
    return Colors.red.shade600;
  }

  List<Widget> _buildSteps() {
    final steps = [
      _StepData(
        label: 'Audio transcribed',
        icon: Icons.check_rounded,
        color: const Color(0xFF4FC3F7),
      ),
      _StepData(
        label: 'Ready to review',
        icon: Icons.schedule_rounded,
        color: Colors.white.withOpacity(0.2),
      ),
    ];

    return steps.asMap().entries.map((e) {
      final i = e.key;
      final step = e.value;
      return AnimatedOpacity(
        duration: const Duration(milliseconds: 400),
        opacity: _stepVisible[i] ? 1.0 : 0.0,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 48, vertical: 5),
          child: Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: step.color.withOpacity(0.18),
                ),
                child: step.spinning
                    ? AnimatedBuilder(
                        animation: _spinController,
                        builder: (_, __) => Transform.rotate(
                          angle: _spinController.value * 2 * pi,
                          child: Icon(step.icon, size: 13, color: step.color),
                        ),
                      )
                    : Icon(step.icon, size: 13, color: step.color),
              ),
              const SizedBox(width: 10),
              Text(
                step.label,
                style: TextStyle(
                  fontSize: 13,
                  color: i < 2
                      ? step.color
                      : Colors.white.withOpacity(i == 2 ? 0.45 : 0.25),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}

class _StepData {
  final String label;
  final IconData icon;
  final Color color;
  final bool spinning;
  _StepData({
    required this.label,
    required this.icon,
    required this.color,
    this.spinning = false,
  });
}

class _ArcPainter extends CustomPainter {
  final Color color;
  _ArcPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromLTWH(2, 2, size.width - 4, size.height - 4),
      -pi / 2,
      pi * 1.2,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_ArcPainter old) => old.color != color;
}


@RoutePage()
class AddDiagnosisPage extends StatefulWidget {
  const AddDiagnosisPage({
    super.key,
    required this.patientId,
    required this.complaintId, required this.visitIndex,

  });

  final String patientId;
  final String complaintId;
  final int visitIndex;

  @override
  State<AddDiagnosisPage> createState() => _AddDiagnosisPageState();
}

class _AddDiagnosisPageState extends State<AddDiagnosisPage> {
  List<MedicationFieldSet> medicationFieldSets = [];
  List<MedicationControllers> medicationControllersList = [];
  String formatedJoiDate = "";

  List<VitalControllers> vitalsControllersList = [];



  final TextEditingController complaintController = TextEditingController();
  final TextEditingController diagnosisController = TextEditingController();
  final TextEditingController medicaladviceController = TextEditingController();
  final TextEditingController labtestController = TextEditingController();
  final TextEditingController doctorremarkController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final formkey = GlobalKey<FormState>();

  final GlobalKey complaintFieldKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();

final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  bool _isPaused = false;
  bool _isTranscribing = false;
  String? _sttError;
  bool _showVoiceOverlay = false;
  VoiceOverlayState _voiceState = VoiceOverlayState.recording;
  String? _currentRecordingPath;
  final SttServiceIPD _sttService = SttServiceIPD();

  // ← Track whether the STT call was cancelled mid-flight
  bool _analysisCancelled = false;

    final SecureStorage secureStorage = SecureStorage();


  @override
  void initState() {
    super.initState();
    medicationControllersList.add(MedicationControllers());
    vitalsControllersList.add(VitalControllers());
    _warmupModal();
  }

  void addVital() {
  setState(() {
    vitalsControllersList.add(VitalControllers());
  });
}

  void addMedication() {
    setState(() {
      medicationControllersList.add(MedicationControllers());
    });
  }

Future<void> refreshtoken() async {
    try {
      Constants.doctorrefreshtoken =
          await secureStorage.readSecureData('refreshtoken') ?? '';
      final resp = await http.post(
        Uri.parse(
            '${Constants.baseUrl}/api/v1/hospitaldoctor/refreshtokendoctoradminmobile'),
        headers: {
          'Authorization': 'Bearer ${Constants.doctorrefreshtoken}',
          'Content-Type': 'application/json',
        },
      );
      // if (resp.statusCode == 200) {
      //   final d = jsonDecode(resp.body);
      //   await secureStorage.writeSecureData('token', d['token']);
      //   await secureStorage.writeSecureData('refreshtoken', d['refreshToken']);
      //   Constants.token = await secureStorage.readSecureData('token');
      //   Constants.refreshtoken =
      //       await secureStorage.readSecureData('refreshtoken');
      // } else {
      //   secureStorage.deleteSecureData('token');
      //   secureStorage.deleteSecureData('refreshtoken');
      //   if (mounted) context.router.popAndPush(SplashRoute());
      // }

      if (resp.statusCode == 200) {
        final responseData = jsonDecode(resp.body);
        await secureStorage.writeSecureData('token', responseData['token']);
        await secureStorage.writeSecureData('refreshtoken', responseData['refreshToken']);
        Constants.doctortoken = responseData['token'];
        Constants.doctorrefreshtoken = responseData['refreshToken'];
        print("Constants.doctortoken ${Constants.doctortoken}");
        print("Constants.doctorrefreshtoken ${Constants.doctorrefreshtoken}");

      } else if (resp.statusCode == 401 || resp.statusCode == 403) {
        // Only logout on auth errors
        await secureStorage.deleteSecureData('token');
        await secureStorage.deleteSecureData('refreshtoken');
        Constants.doctortoken = '';
        Constants.doctorrefreshtoken = '';
        if (mounted) context.router.popAndPush(SplashRoute());

      } else {
        // 500 or any other error — DO NOT logout, just print
        print("Refresh failed with status: ${resp.statusCode} — ${resp.body}");
      }
    } catch (e) {
      debugPrint('refreshtoken: $e');
    }
  }


  Future<void> _warmupModal() async {
  try {
    print("Called warmup model");
   final resp = await http.post(
      Uri.parse('${Constants.baseUrl}/api/v1/hospitaldoctor/warmup'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Constants.token}',
      },
    );
    print("response: ${resp.body}");
  } catch (e) {
    print(e);
    debugPrint('warmup: $e'); // fire-and-forget, ignore errors
  }
}

Future<void> _startVoiceRecording() async {
  final ok = await _audioRecorder.hasPermission();
  if (!ok) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Microphone permission denied.')),
    );
    return;
  }

  final dir = await getTemporaryDirectory();
  final path = p.join(dir.path,
      'voice_rx_${DateTime.now().millisecondsSinceEpoch}.m4a');

  // ✅ Just start recording — warmup already happened at page load
  await _audioRecorder.start(
    const RecordConfig(
      encoder: AudioEncoder.aacLc,
      bitRate: 128000,
      sampleRate: 44100,
    ),
    path: path,
  );

  setState(() {
    _isRecording = true;
    _isPaused = false;
    _sttError = null;
    _showVoiceOverlay = true;
    _voiceState = VoiceOverlayState.recording;
    _currentRecordingPath = path;
    _analysisCancelled = false;
  });
}

Future<void> _pauseRecording() async {
    try {
      await _audioRecorder.pause();
      setState(() {
        _isPaused = true;
        _voiceState = VoiceOverlayState.paused;
      });
    } catch (e) {
      debugPrint('pause error: $e');
    }
  }

  Future<void> _resumeRecording() async {
    try {
      await _audioRecorder.resume();
      setState(() {
        _isPaused = false;
        _voiceState = VoiceOverlayState.recording;
      });
    } catch (e) {
      debugPrint('resume error: $e');
    }
  }

  Future<void> _cancelRecording() async {
    try {
      await _audioRecorder.stop();
      if (_currentRecordingPath != null) {
        final file = File(_currentRecordingPath!);
        if (await file.exists()) await file.delete();
      }
    } catch (e) {
      debugPrint('cancel recording: $e');
    }
    setState(() {
      _isRecording = false;
      _isPaused = false;
      _isTranscribing = false;
      _showVoiceOverlay = false;
      _voiceState = VoiceOverlayState.recording;
      _currentRecordingPath = null;
      _sttError = null;
      _analysisCancelled = false;
    });
  }

  void _cancelAnalyzing() {
    _analysisCancelled = true;
    setState(() {
      _isTranscribing = false;
      _showVoiceOverlay = false;
      _voiceState = VoiceOverlayState.recording;
      _sttError = null;
    });
    // Note: the in-flight HTTP request will still complete on the server side,
    // but the result is simply ignored because _analysisCancelled == true.
  }

  Future<void> _stopAndTranscribe() async {
    final filePath = await _audioRecorder.stop();

    setState(() {
      _isRecording = false;
      _isPaused = false;
      _isTranscribing = true;
      _voiceState = VoiceOverlayState.analyzing;
      _sttError = null;
      _analysisCancelled = false;
    });

    if (filePath == null) {
      setState(() {
        _isTranscribing = false;
        _showVoiceOverlay = false;
        _sttError = 'Recording failed. Please try again.';
      });
      return;
    }

    try {
      final result = await _sttService.transcribeAudio(filePath);

      // If the user cancelled while the request was in-flight, ignore result
      if (_analysisCancelled) return;

      _fillAllFields(result);
      await Future.delayed(const Duration(milliseconds: 500));
      if (!_analysisCancelled) {
        setState(() {
          _showVoiceOverlay = false;
          _isTranscribing = false;
        });
      }
    } 
    // catch (e) {
    //   if (_analysisCancelled) return;


    //   if (e.toString().contains('UNAUTHORIZED')) {
    //   refreshtoken();
    //     try {
    //       final retry = await _sttService.transcribeAudio(filePath);
    //       if (_analysisCancelled) return;
    //       _fillAllFields(retry);
    //       await Future.delayed(const Duration(milliseconds: 500));
    //       if (!_analysisCancelled) {
    //         setState(() {
    //           _showVoiceOverlay = false;
    //           _isTranscribing = false;
    //         });
    //       }
    //     } catch (e2) {
    //       if (_analysisCancelled) return;
    //       setState(() {
    //         _sttError = 'Failed: $e2';
    //         _showVoiceOverlay = false;
    //         _isTranscribing = false;
    //       });
    //     }
    //   } else {
    //     setState(() {
    //       _sttError = 'Error: $e';
    //       _showVoiceOverlay = false;
    //       _isTranscribing = false;
    //     });
    //   }
    // }
    catch (e) {
  if (_analysisCancelled) return;

  final msg = e.toString();
  if (msg.contains('UNAUTHORIZED')) {
    refreshtoken();
    // ...existing refresh/retry logic
  } else if (msg.contains('TIMEOUT')) {
    setState(() {
      _sttError = 'This is taking longer than usual. Please try again — '
          'shorter recordings process faster.';
      _showVoiceOverlay = false;
      _isTranscribing = false;
    });
  } else {
    setState(() {
      _sttError = 'Something went wrong. Please try again.';
      _showVoiceOverlay = false;
      _isTranscribing = false;
    });
  }
}
  }

  void _fillAllFields(Map<String, dynamic> apiResponse) {
    if (apiResponse['success'] != true) {
      setState(() => _sttError = 'API returned unsuccessful response.');
      return;
    }

    final data = apiResponse['data'] as Map<String, dynamic>;

    setState(() {
      if (data['diagnosis_summary'] != null)
        diagnosisController.text = _stripHtml(data['diagnosis_summary']);
      if (data['medical_advice'] != null)
        medicaladviceController.text = _stripHtml(data['medical_advice']);
      if (data['lab_test'] != null) {
        final lt = data['lab_test'];
        labtestController.text =
            lt is List ? lt.join(', ') : _stripHtml(lt.toString());
      }
      if (data['doctors_remark'] != null)
        doctorremarkController.text = _stripHtml(data['doctors_remark']);
      if (data['follow_up_date'] != null &&
          (data['follow_up_date'] as String).isNotEmpty) {
        try {
          final parsed = DateTime.parse(data['follow_up_date']);
          dateController.text = DateFormat('dd/MM/yyyy').format(parsed);
          formatedJoiDate = DateFormat('yyyy-MM-dd').format(parsed);
        } catch (_) {
          dateController.text = data['follow_up_date'];
        }
      }

      // if (data['medications'] != null) {
      //   final List<dynamic> meds = data['medications'];
      //   if (meds.isNotEmpty) {
      //     for (var c in medicationControllersList) c.dispose();
      //     medicationControllersList.clear();
      //     for (final med in meds) {
      //       final c = MedicationControllers();
      //       c.medicineController.text = med['name'] ?? '';
      //       c.typeController.text = med['type'] ?? '';
      //       c.foodOptionController.text = med['food'] ?? '';
      //       c.powerController.text = med['power']?.toString() ?? '';
      //       c.countController.text = med['count']?.toString() ?? '';
      //       c.durationController.text = med['duration']?.toString() ?? '';
      //       c.specialInstructionController.text =
      //           med['special_instruction'] ?? '';
      //       if (med['time'] != null)
      //         c.selectedTimes = List<String>.from(med['time'] as List);
      //       medicationControllersList.add(c);
      //     }
      //   }
      // }
      if (data['medications'] != null) {
        final List<dynamic> meds = data['medications'];
        if (meds.isNotEmpty) {
          for (var c in medicationControllersList) c.dispose();
          medicationControllersList.clear();
          for (final med in meds) {
            final c = MedicationControllers();
            c.medicineController.text = med['name'] ?? '';
            c.typeController.text = med['type'] ?? '';
            c.foodOptionController.text = med['food'] ?? '';
            c.powerController.text = med['power']?.toString() ?? '';
            c.countController.text = med['count']?.toString() ?? '';
            c.durationController.text = med['duration']?.toString() ?? '';
            c.specialInstructionController.text =
                med['special_instruction'] ?? '';
            if (med['time'] != null)
              c.selectedTimes = List<String>.from(med['time'] as List);
            medicationControllersList.add(c);
          }
        }
      }

      // ── NEW: Vitals from voice transcription ──
      if (data['vitals'] != null) {
        final List<dynamic> vitals = data['vitals'];
        if (vitals.isNotEmpty) {
          for (var c in vitalsControllersList) c.dispose();
          vitalsControllersList.clear();
          for (final v in vitals) {
            final c = VitalControllers();
            c.nameController.text = v['name']?.toString() ?? '';
            c.valueController.text = v['value']?.toString() ?? '';
            vitalsControllersList.add(c);
          }
          // Ensure at least one empty row remains so the user can add more
          if (vitalsControllersList.isEmpty) {
            vitalsControllersList.add(VitalControllers());
          }
        }
      }
    });
  }

  String _stripHtml(String html) => html
      .replaceAll(RegExp(r'<[^>]*>'), ' ')
      .replaceAll('&amp;', '&')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&nbsp;', ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  String formatJoiDate(String pickedDate) {
    final parsedDate = DateTime.parse(pickedDate);
    final formattedJoiDate = DateFormat('yyyy-MM-dd').format(parsedDate);
    return formattedJoiDate;
  }

  List<File> selectedFiles = [];

void _showPickerOptions() {
  if (selectedFiles.length >= 5) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Maximum 5 files allowed")),
    );
    return;
  }

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            width: 36, height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.camera_alt_rounded, color: Colors.blue),
            ),
            title: const Text('Camera'),
            subtitle: const Text('Take a photo now'),
            onTap: () {
              Navigator.pop(context);
              _pickFromCamera();
            },
          ),
          const Divider(indent: 16, endIndent: 16, height: 1),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.folder_rounded, color: Colors.green),
            ),
            title: const Text('Files'),
            subtitle: const Text('jpg, png, pdf, doc, docx · max 5MB'),
            onTap: () {
              Navigator.pop(context);
              pickFiles();
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
}

Future<void> _pickFromCamera() async {
  final ImagePicker picker = ImagePicker();
  final XFile? photo = await picker.pickImage(
    source: ImageSource.camera,
    imageQuality: 85,   // keeps file size reasonable
  );

  if (photo == null) return;

  final File imageFile = File(photo.path);
  const int maxFileSizeBytes = 5 * 1024 * 1024;

  if (await imageFile.length() > maxFileSizeBytes) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Photo exceeds 5MB limit")),
    );
    return;
  }

  if (selectedFiles.length + 1 > 10) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("You can select maximum 10 files only")),
    );
    return;
  }

  setState(() {
    selectedFiles.add(imageFile);
  });
}

  // Future<void> pickFiles() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     allowMultiple: true,
  //     type: FileType.custom,
  //     allowedExtensions: ['jpg', 'png', 'pdf', 'doc', 'docx'],
  //   );

  //   if (result != null) {
  //     setState(() {
  //       selectedFiles = result.paths.map((path) => File(path!)).toList();
  //     });
  //     print("Selected ${selectedFiles.length} files");
  //   } else {
  //     print("No files selected");
  //   }
  // }

Future<void> pickFiles() async {

  if (selectedFiles.length >= 5) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Maximum 5 files allowed"),
      ),
    );
    return;
  }

  FilePickerResult? result = await FilePicker.platform.pickFiles(
    allowMultiple: true,
    type: FileType.custom,
    allowedExtensions: ['jpg', 'png', 'pdf', 'doc', 'docx'],
  );

  if (result != null) {

    const int maxFileSizeBytes = 5 * 1024 * 1024; // 5MB in bytes

    // Filter out files exceeding 5MB
    List<PlatformFile> oversizedFiles = result.files
        .where((file) => (file.size) > maxFileSizeBytes)
        .toList();

    if (oversizedFiles.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Cannot upload files larger than 5MB: ${oversizedFiles.map((f) => f.name).join(', ')}",
          ),
        ),
      );
      return;
    }

    List<File> newFiles =
        result.paths.map((path) => File(path!)).toList();

    // Check total limit
    if (selectedFiles.length + newFiles.length > 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You can select maximum 10 files only"),
        ),
      );
      return;
    }

    setState(() {
      selectedFiles.addAll(newFiles);
    });

    print("Selected ${selectedFiles.length} files");
  } else {
    print("No files selected");
  }
}

  @override
  void dispose() {
     _audioRecorder.dispose();
    diagnosisController.dispose();
    medicaladviceController.dispose();
    labtestController.dispose();
    doctorremarkController.dispose();
    dateController.dispose();
    for (var controllers in medicationControllersList) {
      controllers.dispose();
    }
     for (var controllers in vitalsControllersList) {
    controllers.dispose();
  }
    super.dispose();
  }

  // Future<List<Map<String, dynamic>>> fetchMedicineSuggestions(String query) async {
  //   if (query.isEmpty) return [];
    
  //   try {
  //     final response = await http.get(
  //       Uri.parse('${Constants.baseUrl}/api/v1/doctor/suggestion-medicine?search=$query',
        
  //       ),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer ${Constants.token}',
  //       },
  //     );
      
  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //       print(data);
  //       if (data['success'] == true && data['medicines'] != null) {
  //         return List<Map<String, dynamic>>.from(data['medicines']);
  //       }
  //     }
  //   } catch (e) {
  //     print('Error fetching medicine suggestions: $e');
  //   }
    
  //   return [];
  // }

  @override
  Widget build(BuildContext context) {
    final allPaths = selectedFiles.map((file) => file.path.split('/').last).join(', ');

    Doctorprovider doctorprovider = context.read<Doctorprovider>();
    
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
             flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
              ),
            ),
            leading: IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: Icon(Icons.arrow_back,
            color: Colors.white,)),
            title: const Text(
              'Patient Diagnosis',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        
        floatingActionButton: _showVoiceOverlay
                  ? null
                  : Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(50)),
                        gradient: AppColors.primaryGradient,
                      ),
                      child: ElevatedButton(
                        style: const ButtonStyle(
                          shadowColor: WidgetStatePropertyAll(Colors.transparent),
                          backgroundColor:
                              WidgetStatePropertyAll(Colors.transparent),
                          foregroundColor: WidgetStatePropertyAll(Colors.white),
                        ),
                        onPressed: _startVoiceRecording,
                        child: const Icon(Icons.mic_rounded,
                            color: Colors.white, size: 30),
                      ),
                    ),
        
                              floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        
        
          body: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            child: Form(
              key: formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_sttError != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline,
                              color: Colors.red, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                              child: Text(_sttError!,
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 13))),
                          GestureDetector(
                            onTap: () => setState(() => _sttError = null),
                            child: const Icon(Icons.close,
                                color: Colors.red, size: 18),
                          ),
                        ],
                      ),
                    ),

                   const Text(
                    "Complaint*",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    key: complaintFieldKey,
                    controller: complaintController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Complaint';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Complaint',
                    ),
                  ),
                  SizedBox(height: 12,),
                  const Text(
                    "Diagnosis",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                   
                    controller: diagnosisController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Diagnosis';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Diagnosis',
                    ),
                  ),
                  const SizedBox(height: 12),
                  
        const Text(
          "Vitals",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        
        ...vitalsControllersList.asMap().entries.map((entry) {
          final index = entry.key;
          final controllers = entry.value;
          return VitalsFieldSet(
        controllers: controllers,
          );
        }).toList(),
        
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: ElevatedButton(
        onPressed: addVital,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
        child: const Text(
          "Add Vital",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
          ),
        ),
        
        const SizedBox(height: 12),
        
                  
                  // Updated medication field sets with autocomplete
                  ...medicationControllersList
                      .map((controllers) => MedicationFieldSet(
                            controllers: controllers,
                            // fetchMedicineSuggestions: fetchMedicineSuggestions,
                          ))
                      .toList(),
        
                  const SizedBox(height: 12),
                  Container(
                     decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
                    child: ElevatedButton(
                      onPressed: addMedication,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:  Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                      child: const Text("Add Medication",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          )),
                    ),
                  ),
                  
                  // ... rest of your form fields remain the same
                  const SizedBox(height: 12),
                  const Text(
                    "Medical Advice",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: medicaladviceController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Medical Advice',
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  const Text(
                    "Lab Tests",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: labtestController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Lab Tests',
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  const Text(
                    "Supporting Files",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Container(
                     decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
                    child: ElevatedButton(
                      onPressed: _showPickerOptions,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                      child: const Text(
                        'Pick Files',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  if (selectedFiles.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(selectedFiles.length, (index) {
                        final file = selectedFiles[index];
                        final extension = file.path.split('.').last.toLowerCase();
                        final isImage = ['jpg', 'jpeg', 'png'].contains(extension);
        
                        return Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: isImage
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: Image.file(
                                        file,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.insert_drive_file,
                                            size: 40, color: Colors.blue),
                                        const SizedBox(height: 5),
                                        Text(
                                          file.path.split('/').last,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                      ],
                                    ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedFiles.removeAt(index);
                                });
                              },
                              child: const CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.red,
                                child: Icon(Icons.close, size: 12, color: Colors.white),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
        
                  if (selectedFiles.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'No files selected',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  const SizedBox(height: 12),
                  
                  const Text(
                    "Next Visit Date",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: dateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: GestureDetector(
                            onTap: () async {
                              DateTime today = DateTime.now();
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: today,
                                firstDate: today,
                                lastDate: DateTime(2101),
                              );
        
                              if (pickedDate != null) {
                                String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
                                dateController.text = formattedDate;
                                formatedJoiDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                              }
                            },
                            child: const Icon(Icons.calendar_month_outlined)),
                      ),
                      border: const OutlineInputBorder(),
                      hintText: 'dd/MM/yyyy',
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  const Text(
                    "Doctors remark",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: doctorremarkController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Doctors remark',
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  Container(
                    width: double.infinity,
                     decoration: BoxDecoration(
        gradient:doctorprovider.isSavingIndiagnosis?LinearGradient(colors: [
          Colors.grey, Colors.grey
        ]): AppColors.primaryGradient,
        borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
                    child: ElevatedButton(
                      onPressed:doctorprovider.isSavingIndiagnosis ? null : () async {
        
                       
                                    
                        if (!formkey.currentState!.validate()) {
                           
                          if (diagnosisController.text.isEmpty) {
                            Scrollable.ensureVisible(
                              complaintFieldKey.currentContext!,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          }
                          return;
                        }
        
                        List<Map<String, dynamic>> medicationList = medicationControllersList
                            .where((controllers) => controllers.medicineController.text.trim().isNotEmpty)
                            .map((controllers) {
                          return {
                            'medicine': controllers.medicineController.text,
                            'type': controllers.typeController.text,
                            'food': controllers.foodOptionController.text,
                            'time': controllers.selectedTimes,
                            'power': controllers.powerController.text,
                            'count': controllers.countController.text,
                            'duration': controllers.durationController.text,
                            'special_instruction': controllers.specialInstructionController.text,
                          };
                        }).toList();
        
                        List<Map<String, dynamic>> vitalsList = vitalsControllersList
        .where((controllers) => controllers.nameController.text.trim().isNotEmpty)
        .map((controllers) {
          return {
        'name': controllers.nameController.text,
        'value': controllers.valueController.text,
          };
        }).toList();
        
        print(vitalsList);
        
         setState(() {
                                      doctorprovider.isSavingIndiagnosis = true;
                                    });
                        await doctorprovider.addinpatientdiagnosis(
                            widget.patientId,
                            widget.complaintId,
                            widget.visitIndex,
                            complaintController.text,
                            diagnosisController.text,
                            medicaladviceController.text,
                            labtestController.text,
                            doctorremarkController.text,
                            formatedJoiDate,
                            vitalsList,
                            medicationList,
                            
                            selectedFiles,
                            context);
        
                        // doctorprovider todaysvisitprovider = context.read<Todayvisitprovider>();
                        await doctorprovider.getpatientdiagnosis(widget.patientId,widget.visitIndex, context);
                        doctorprovider.notify();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: doctorprovider.isSavingIndiagnosis ? Colors.transparent :Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      child:
                      doctorprovider.isSavingIndiagnosis ? const CircularProgressIndicator():
                       const Text("Save Report",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        if (_showVoiceOverlay)
          Positioned.fill(
            child: VoiceRecordingOverlay(
              state: _voiceState,
              errorMessage: _sttError,
              onStop: _stopAndTranscribe,
              onCancel: _cancelRecording,
              onPause: _pauseRecording,
              onResume: _resumeRecording,
              onCancelAnalyzing: _cancelAnalyzing, // ← NEW
            ),
          ),
      ],
    );
  }
}

class MedicationControllers {
  final TextEditingController medicineController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController foodOptionController = TextEditingController();
  final TextEditingController powerController = TextEditingController();
  final TextEditingController countController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController specialInstructionController = TextEditingController();

  List<String> selectedTimes = [];

  void dispose() {
    medicineController.dispose();
    typeController.dispose();
    foodOptionController.dispose();
    powerController.dispose();
    countController.dispose();
    durationController.dispose();
    specialInstructionController.dispose();
  }
}

class MedicationFieldSet extends StatefulWidget {
  final MedicationControllers controllers;
  // final Future<List<Map<String, dynamic>>> Function(String) fetchMedicineSuggestions;

  const MedicationFieldSet({
    required this.controllers,
    // required this.fetchMedicineSuggestions,
  });

  @override
  State<MedicationFieldSet> createState() => _MedicationFieldSetState();
}

class _MedicationFieldSetState extends State<MedicationFieldSet> {
  bool isMedicationNameAdded = false;
  List<Map<String, dynamic>> suggestions = [];
  bool showSuggestions = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  final FocusNode _focusNode = FocusNode();
  bool _isSelecting = false; // Flag to prevent showing suggestions during selection
  
  @override
  void initState() {
    super.initState();
    widget.controllers.medicineController.addListener(_onMedicineTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    widget.controllers.medicineController.removeListener(_onMedicineTextChanged);
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onFocusChanged() {
    if (!_focusNode.hasFocus) {
      _removeOverlay();
    }
  }
  
  void _onMedicineTextChanged() async {
    // Don't show suggestions if we're in the middle of selecting
    if (_isSelecting) {
      return;
    }

    final query = widget.controllers.medicineController.text;
    
    setState(() {
      isMedicationNameAdded = query.isNotEmpty;
    });

    // if (query.length >= 1) {
    //   final fetchedSuggestions = await widget.fetchMedicineSuggestions(query);
    //   setState(() {
    //     suggestions = fetchedSuggestions;
        
    //   });
      
    //   if (fetchedSuggestions.isNotEmpty && _focusNode.hasFocus) {
    //     _showOverlay();
    //   } else {
    //     _removeOverlay();
    //   }
    // } else {
    //   setState(() {
    //     suggestions = [];
    //   });
    //   _removeOverlay();
    // }
  }

  void _showOverlay() {
    _removeOverlay(); // Remove existing overlay first
    
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: _getTextFieldWidth(),
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 60), // Adjust this offset as needed
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: suggestions.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  color: Colors.grey.shade200,
                ),
                itemBuilder: (context, index) {
                  final suggestion = suggestions[index];
                  return InkWell(
                    onTap: () => _selectSuggestion(suggestion['name'] ?? ''),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Text(
                        suggestion['name'] ?? '',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _selectSuggestion(String medicineName) {
    _isSelecting = true; // Set flag to prevent suggestions
    
    widget.controllers.medicineController.text = medicineName;
    _removeOverlay();
    setState(() {
      isMedicationNameAdded = true;
    });
    
    // Move cursor to end of text
    widget.controllers.medicineController.selection = TextSelection.fromPosition(
      TextPosition(offset: medicineName.length),
    );
    
    // Reset the flag after a short delay to allow normal typing again
    Future.delayed(const Duration(milliseconds: 300), () {
      _isSelecting = false;
    });

    print(_isSelecting);
  }

  double _getTextFieldWidth() {
    // Calculate the width of the text field
    // You might need to adjust this based on your layout
    final screenWidth = MediaQuery.of(context).size.width;
    return (screenWidth - 32 - 10) / 2; // Considering padding and spacing
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Medication',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: CompositedTransformTarget(
                link: _layerLink,
                child: TextField(
                  controller: widget.controllers.medicineController,
                  focusNode: _focusNode,
                  decoration: const InputDecoration(
                    hintText: 'Medicine',
                    border: OutlineInputBorder(),
                  ),
                  // onTap: () {
                  //   print('_isSelecting ${_isSelecting}');
                  //   // Only show overlay if not selecting and has suggestions
                  //   if (suggestions.isNotEmpty && !_isSelecting) {
                  //     _showOverlay();
                  //   }
                  // },
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  enabled: isMedicationNameAdded,
                  hintText: 'Select Type',
                  border: OutlineInputBorder(),
                ),
                items: [
                  "Tablet",
                  "Ointment",
                  "Injection",
                  "IV",
                  "Supporter",
                  "Drops",
                  "Bandage",
                  "Syrup",
                  "Others",
                ]
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: isMedicationNameAdded
                    ? (value) {
                        widget.controllers.typeController.text = value!;
                      }
                    : null,
                onSaved: (newValue) {
                  widget.controllers.typeController.text = newValue!;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: widget.controllers.powerController,
                decoration: InputDecoration(
                  enabled: isMedicationNameAdded,
                  hintText: 'Power',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: widget.controllers.countController,
                decoration: InputDecoration(
                  enabled: isMedicationNameAdded,
                  hintText: 'Count',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            enabled: isMedicationNameAdded,
            hintText: 'Select Food option',
            border: OutlineInputBorder(),
          ),
          items: ["Before food", "After Food", "NA"]
              .map((option) => DropdownMenuItem(
                    value: option,
                    child: Text(option),
                  ))
              .toList(),
          onChanged: isMedicationNameAdded
              ? (value) {
                  widget.controllers.foodOptionController.text = value!;
                }
              : null,
          onSaved: (newValue) {
            widget.controllers.foodOptionController.text = newValue!;
          },
        ),
       
        const SizedBox(height: 10),
        GestureDetector(
          onTap: isMedicationNameAdded
              ? () async {
                  final List<String> options = [
                    "Morning",
                    "AfterNoon",
                    "Evening",
                    "Night"
                  ];
                  final selected = await showDialog<List<String>>(
                    context: context,
                    builder: (BuildContext context) {
                      List<String> tempSelected = List.from(widget.controllers.selectedTimes);

                      return Dialog(
                        insetPadding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Select Times for Medicine',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              StatefulBuilder(
                                builder: (context, setState) {
                                  return SingleChildScrollView(
                                    child: Column(
                                      children: options.map((option) {
                                        final bool isSelected = tempSelected.contains(option);
                                        return InkWell(
                                          onTap: () {
                                            setState(() {
                                              if (isSelected) {
                                                tempSelected.remove(option);
                                              } else {
                                                tempSelected.add(option);
                                              }
                                            });
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            margin: const EdgeInsets.symmetric(vertical: 6),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 12),
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? Color(0xFF0857C0)
                                                  : Colors.grey[200],
                                            ),
                                            child: Text(
                                              option,
                                              style: TextStyle(
                                                color: isSelected
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontWeight: isSelected
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 10),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, tempSelected);
                                },
                                child: const Text(
                                  'OK',
                                  style: TextStyle(
                                    color: Color(0xFF0857C0),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );

                  if (selected != null) {
                    setState(() {
                      widget.controllers.selectedTimes = selected;
                    });
                  }
                }
              : () {},
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: isMedicationNameAdded
                  ? Border.all(color: Colors.grey)
                  : Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.controllers.selectedTimes.isEmpty
                        ? 'Select time for taking medicine'
                        : widget.controllers.selectedTimes.join(', '),
                    style: TextStyle(
                        fontSize: 16,
                        color: isMedicationNameAdded ? Colors.black : Colors.grey),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: isMedicationNameAdded ? Colors.black : Colors.grey,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: widget.controllers.durationController,
                decoration: InputDecoration(
                  enabled: isMedicationNameAdded,
                  hintText: 'Duration in days',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: widget.controllers.specialInstructionController,
                decoration: InputDecoration(
                  enabled: isMedicationNameAdded,
                  hintText: 'Special Instruction',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class VitalControllers {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController valueController = TextEditingController();

  void dispose() {
    nameController.dispose();
    valueController.dispose();
  }
}

class VitalsFieldSet extends StatefulWidget {
  final VitalControllers controllers;

  const VitalsFieldSet({
    Key? key,
    required this.controllers,
  }) : super(key: key);

  @override
  State<VitalsFieldSet> createState() => _VitalsFieldSetState();
}

class _VitalsFieldSetState extends State<VitalsFieldSet> {
  bool isValueEnabled = false;

 @override
  void initState() {
    super.initState();
    // Listen to changes in name field
    widget.controllers.nameController.addListener(_checkNameField);
  }

   void _checkNameField() {
    final isNotEmpty = widget.controllers.nameController.text.trim().isNotEmpty;
    if (isNotEmpty != isValueEnabled) {
      setState(() {
        isValueEnabled = isNotEmpty;
      });
    }
  }

    @override
  void dispose() {
    widget.controllers.nameController.removeListener(_checkNameField);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.controllers.nameController,
              decoration: const InputDecoration(
                hintText: 'Name (e.g. Temperature)',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: widget.controllers.valueController,
              enabled: isValueEnabled,
              decoration: const InputDecoration(
                hintText: 'Value (e.g. 101°F)',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


