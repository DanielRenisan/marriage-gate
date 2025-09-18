import 'package:flutter/material.dart';
import 'dart:math' as math;

class BackgroundSvg extends StatefulWidget {
  const BackgroundSvg({super.key});

  @override
  State<BackgroundSvg> createState() => _BackgroundSvgState();
}

class _BackgroundSvgState extends State<BackgroundSvg>
    with TickerProviderStateMixin {
  late AnimationController _wave1Controller;
  late AnimationController _wave2Controller;

  @override
  void initState() {
    super.initState();
    _wave1Controller = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();

    _wave2Controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _wave1Controller.dispose();
    _wave2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: CustomPaint(
        painter: BackgroundPainter(
          wave1Animation: _wave1Controller,
          wave2Animation: _wave2Controller,
        ),
      ),
    );
  }
}

class BackgroundPainter extends CustomPainter {
  final Animation<double> wave1Animation;
  final Animation<double> wave2Animation;

  BackgroundPainter({
    required this.wave1Animation,
    required this.wave2Animation,
  }) : super(repaint: Listenable.merge([wave1Animation, wave2Animation]));

  @override
  void paint(Canvas canvas, Size size) {
    const baseGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFFF0000),
        Color(0xFFFFFFFF),
        Color(0xFFFFD700),
      ],
      stops: [0.0, 0.5, 1.0],
    );

    final baseRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final basePaint = Paint()..shader = baseGradient.createShader(baseRect);
    canvas.drawRect(baseRect, basePaint);

    // Wave gradient
    const waveGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0x4DFF0000),
        Color(0x4DFFD700),
      ],
    );

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Wave 1
    final wave1Paint = Paint()
      ..shader = waveGradient.createShader(baseRect)
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.translate(centerX, centerY);
    canvas.rotate(wave1Animation.value * 2 * math.pi);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(0, size.height * 0.375),
        width: size.width * 1.6,
        height: size.height * 0.8,
      ),
      wave1Paint,
    );
    canvas.restore();

    // Wave 2
    final wave2Paint = Paint()
      ..shader = waveGradient.createShader(baseRect)
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.translate(centerX, centerY);
    canvas.rotate(-wave2Animation.value * 2 * math.pi);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(0, size.height * 0.3125),
        width: size.width * 1.8,
        height: size.height * 0.9,
      ),
      wave2Paint,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
