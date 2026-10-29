import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class GridPaperBackground extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;

  const GridPaperBackground({
    super.key,
    required this.child,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? AppPalette.background(context);
    return Container(
      color: bg,
      child: CustomPaint(
        painter: _GridPainter(lineColor: AppPalette.gridLine(context)),
        child: child,
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  final Color lineColor;

  _GridPainter({required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor.withValues(alpha: 0.5)
      ..strokeWidth = 0.5;
    const step = 24.0;
    for (var x = 0.0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var y = 0.0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
