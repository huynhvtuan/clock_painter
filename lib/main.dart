import 'package:clock_painter/presentation/clock_custom_painter.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Clock Painter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ClockCustomPainter(),
    );
  }
}
