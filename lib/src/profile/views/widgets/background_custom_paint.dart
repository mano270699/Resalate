import 'package:flutter/material.dart';

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blueAccent
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height * 0.5)
      ..quadraticBezierTo(
          size.width * 0.5, size.height * 0.2, size.width, size.height * 0.5)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class WaveBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xff008673),
          Color(0xff04536e),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height * 0.2) // Reduced from 0.3 to 0.2
      ..quadraticBezierTo(
          size.width * 0.5,
          size.height * 0.3, // Reduced control point from 0.5 to 0.3
          size.width,
          size.height * 0.2) // Reduced end point from 0.3 to 0.2
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class RadialBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Define the radial gradient
    final gradient = RadialGradient(
      colors: [
        Color(0xff008673),
        Color(0xff04536e),
      ],
      center: Alignment(0.5, 0.5),
      radius: 0.8,
    );

    // Create a rectangle that covers the whole canvas
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;

    // Draw the gradient background
    canvas.drawRect(rect, paint);

    // Define the paint for circular patterns
    final circlePaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    // Draw circular patterns
    for (double i = 0; i < size.width; i += 100) {
      for (double j = 0; j < size.height; j += 100) {
        canvas.drawCircle(Offset(i, j), 40, circlePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
