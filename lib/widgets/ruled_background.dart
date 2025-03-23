import 'package:flutter/material.dart';

class RuledBackground extends StatelessWidget {
  final double lineHeight;
  final Widget child;

  const RuledBackground({
    super.key,
    required this.lineHeight,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _RuledPainter(lineHeight), child: child);
  }
}

class _RuledPainter extends CustomPainter {
  final double lineHeight;
  _RuledPainter(this.lineHeight);

  @override
  void paint(Canvas canvas, Size size) {
    const double topPadding = 8;
    final paint = Paint()
      ..color = Colors.grey.withAlpha(77)
      ..strokeWidth = 1;
    for (double y = topPadding + lineHeight; y < size.height; y += lineHeight) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
