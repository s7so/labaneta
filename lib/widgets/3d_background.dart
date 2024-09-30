import 'package:flutter/material.dart';
import 'dart:math' as math;

class ThreeDBackground extends StatefulWidget {
  final Widget child;

  const ThreeDBackground({Key? key, required this.child}) : super(key: key);

  @override
  _ThreeDBackgroundState createState() => _ThreeDBackgroundState();
}

class _ThreeDBackgroundState extends State<ThreeDBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: BackgroundPainter(_controller.value),
              size: Size.infinite,
            );
          },
        ),
        widget.child,
      ],
    );
  }
}

class BackgroundPainter extends CustomPainter {
  final double animationValue;

  BackgroundPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Draw background gradient
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    const gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFFFF0DB),
        Color(0xFFFFD1DC),
      ],
    );
    canvas.drawRect(rect, paint..shader = gradient.createShader(rect));

    // Draw animated shapes
    for (int i = 0; i < 7; i++) {
      final radius = (size.width / 10) * (1 + 0.3 * math.sin(animationValue * 2 * math.pi + i));
      final x = centerX + (size.width / 3) * math.cos(animationValue * 2 * math.pi + i);
      final y = centerY + (size.height / 3) * math.sin(animationValue * 2 * math.pi + i);

      // Draw circle
      paint.color = Colors.white.withOpacity(0.2);
      canvas.drawCircle(Offset(x, y), radius, paint);

      // Draw "cream" swirl
      final swirl = Path()
        ..moveTo(x, y)
        ..quadraticBezierTo(
          x + radius * math.cos(animationValue * 6 * math.pi),
          y + radius * math.sin(animationValue * 6 * math.pi),
          x + radius * 2 * math.cos(animationValue * 3 * math.pi),
          y + radius * 2 * math.sin(animationValue * 3 * math.pi),
        );
      canvas.drawPath(swirl, paint..color = Colors.white.withOpacity(0.15));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}