import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedBackground extends StatefulWidget {
  final Widget child;

  const AnimatedBackground({Key? key, required this.child}) : super(key: key);

  @override
  _AnimatedBackgroundState createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  final List<Color> _colors = [
    const Color(0xFFFFD1DC), // لون الفراولة الفاتح
    const Color(0xFFFFF0DB), // لون الفانيليا
    const Color(0xFFE6F3FF), // لون أزرق فاتح للتزيين
    const Color(0xFFFFF5E6), // لون الكراميل الفاتح
  ];

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      10,
      (index) => AnimationController(
        duration: Duration(seconds: 10 + index * 2),
        vsync: this,
      )..repeat(reverse: true),
    );

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          painter: BackgroundPainter(_animations, _colors),
          child: Container(),
        ),
        widget.child,
      ],
    );
  }
}

class BackgroundPainter extends CustomPainter {
  final List<Animation<double>> animations;
  final List<Color> colors;

  BackgroundPainter(this.animations, this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (var i = 0; i < animations.length; i++) {
      final animation = animations[i];
      final color = colors[i % colors.length];
      final offset = Offset(
        size.width * (0.2 + 0.6 * animation.value),
        size.height * (0.2 + 0.6 * math.sin(animation.value * math.pi)),
      );
      final radius = size.width * 0.2 * (1 + animation.value * 0.5);

      paint.color = color.withOpacity(0.3);
      canvas.drawCircle(offset, radius, paint);

      // إضافة منحنيات للتمثيل الكريمة
      final path = Path()
        ..moveTo(offset.dx - radius, offset.dy)
        ..quadraticBezierTo(
          offset.dx,
          offset.dy + radius * 0.5,
          offset.dx + radius,
          offset.dy,
        );
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}