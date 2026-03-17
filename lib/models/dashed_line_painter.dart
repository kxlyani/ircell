import 'package:flutter/material.dart';

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    
    const double dashWidth = 5;
    const double dashSpace = 5;
    
    double currentX = 0;
    final path = Path();
    
    while (currentX < size.width) {
      path.moveTo(currentX, 0);
      currentX += dashWidth;
      path.lineTo(currentX, 0);
      currentX += dashSpace;
    }
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}