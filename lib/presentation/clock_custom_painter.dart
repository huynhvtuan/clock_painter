import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class ClockCustomPainter extends StatefulWidget {
  const ClockCustomPainter({Key? key}) : super(key: key);

  @override
  State<ClockCustomPainter> createState() => _ClockCustomPainterState();
}

class _ClockCustomPainterState extends State<ClockCustomPainter> {
  double _progress = 0.2;

  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D2F41),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SizedBox(
                  width: 300,
                  height: 300,
                  child: CustomPaint(
                    painter: ClockCustom(progress: _progress),
                  ),
                ),
                const SizedBox(height: 20),
                Slider(
                  value: _progress,
                  min: 0.0,
                  max: 1.0,
                  onChanged: (progress) => setState(() => _progress = progress),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ClockCustom extends CustomPainter {
  final double progress;
  int moneyMax = 250;

  var dateTime = DateTime.now();
  final _textPainter = TextPainter(textDirection: TextDirection.ltr);
  late final TextStyle textStyle;

  ClockCustom({required this.progress});
  @override
  void paint(Canvas canvas, Size size) {
    var centerX = size.width / 2;
    var centerY = size.height / 2;
    var center = Offset(centerX, centerY);
    var radius = min(centerX, centerY);

    var centerFillBrush = Paint()..color = Color.fromARGB(255, 236, 3, 85);

    var minHandBrush = Paint()
      ..shader = const RadialGradient(colors: [Colors.lightBlue, Colors.red])
          .createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 8;

    var dashBrush = Paint()
      ..color = const Color(0xFFEAECFF)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2;

    Paint paint = Paint()
      // ignore: prefer_const_constructors
      ..shader = LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: const [
            Colors.white,
            Color.fromARGB(255, 222, 127, 121),
            Colors.red
          ]).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawArc(
      Rect.fromCenter(
        center: center,
        height: size.height - 40,
        width: size.width - 40,
      ),
      pi,
      pi,
      true,
      paint,
    );
    // canvas.drawCircle(center, radius - 40, fillBrush);
    // canvas.drawCircle(center, radius - 40, outlineBrush);
    double currentMoney = progress * 5 * 36 - 180;
    var secHandX = centerX + 120 * cos(currentMoney * pi / 180);
    var secHandY = centerX + 120 * sin(currentMoney * pi / 180);
    canvas.drawLine(center, Offset(secHandX, secHandY), minHandBrush);
    canvas.drawCircle(center, 16, centerFillBrush);

    var outerCircleRadius = radius;
    var innerCircleRadius = radius - 14;
    for (double i = 180; i <= 360; i += 12) {
      var x1 = centerX + outerCircleRadius * cos(i * pi / 180);
      var y1 = centerX + outerCircleRadius * sin(i * pi / 180);

      var x2 = centerX + innerCircleRadius * cos(i * pi / 180);
      var y2 = centerX + innerCircleRadius * sin(i * pi / 180);
      // canvas.drawLine(Offset(x2, y2), Offset(x1, y1), dashBrush);
      canvas.drawLine(Offset(x2, y2), Offset(x1, y1), dashBrush);
    }

    for (double i = 180; i <= 360; i += 36) {
      var x1 = centerX + (radius + 25) * cos(i * pi / 180);
      var y1 = centerX + (radius + 25) * sin(i * pi / 180);
      // canvas.drawLine(Offset(x2, y2), Offset(x1, y1), dashBrush);
      String money = i == 360
          ? '${((i - 180) / 36 * (moneyMax / 5)).toInt().toString()} Triệu'
          : ((i - 180) / 36 * (moneyMax / 5)).toInt().toString();

      _drawLetter(canvas, money, radius, Offset(x1 - 15, y1 - 15));
    }
  }

  @override
  bool shouldRepaint(covariant ClockCustom oldDelegate) {
    return progress != oldDelegate.progress;
    // return true;
  }

  void _drawLetter(Canvas canvas, String letter, double radius, Offset offset) {
    final textPainter = TextPainter(
        text: TextSpan(
          text: letter,
          style: const TextStyle(
            color: Colors.red,
            fontSize: 20,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center);
    textPainter.layout();
    textPainter.paint(canvas, offset);
  }
}
