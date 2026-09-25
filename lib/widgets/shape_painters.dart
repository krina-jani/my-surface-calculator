import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/calculator_type.dart';

class ShapeIllustrationWidget extends StatelessWidget {
  final ShapeType shapeType;
  final double height;

  const ShapeIllustrationWidget({
    super.key,
    required this.shapeType,
    this.height = 180,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final textColor = isDark ? Colors.white70 : const Color(0xFF334155);

    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: CustomPaint(
        painter: _getPainter(shapeType, primaryColor, textColor),
      ),
    );
  }

  CustomPainter _getPainter(ShapeType type, Color primary, Color text) {
    switch (type) {
      case ShapeType.sphere:
        return SpherePainter(primaryColor: primary, textColor: text);
      case ShapeType.cone:
        return ConePainter(primaryColor: primary, textColor: text);
      case ShapeType.cube:
        return CubePainter(primaryColor: primary, textColor: text);
      case ShapeType.cylinder:
        return CylinderPainter(primaryColor: primary, textColor: text);
      case ShapeType.cuboid:
        return CuboidPainter(primaryColor: primary, textColor: text);
      case ShapeType.capsule:
        return CapsulePainter(primaryColor: primary, textColor: text);
      case ShapeType.sphericalCap:
        return SphericalCapPainter(primaryColor: primary, textColor: text);
      case ShapeType.frustum:
        return FrustumPainter(primaryColor: primary, textColor: text);
      case ShapeType.ellipsoid:
        return EllipsoidPainter(primaryColor: primary, textColor: text);
    }
  }
}

class SpherePainter extends CustomPainter {
  final Color primaryColor;
  final Color textColor;

  SpherePainter({required this.primaryColor, required this.textColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * 0.36;

    // Fill with subtle radial gradient
    final fillPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          primaryColor.withOpacity(0.35),
          primaryColor.withOpacity(0.1),
        ],
        center: const Alignment(-0.3, -0.4),
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, fillPaint);

    // Outline
    final strokePaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawCircle(center, radius, strokePaint);

    // Equator dashed/dotted line
    final dashPaint = Paint()
      ..color = primaryColor.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawOval(
      Rect.fromCenter(center: center, width: radius * 2, height: radius * 0.6),
      dashPaint,
    );

    // Radius line and label 'r'
    final rPaint = Paint()
      ..color = Colors.amber.shade700
      ..strokeWidth = 2.0;
    canvas.drawLine(center, Offset(center.dx + radius, center.dy), rPaint);
    canvas.drawCircle(center, 3, rPaint);

    _drawText(canvas, 'r', Offset(center.dx + radius / 2, center.dy - 18), Colors.amber.shade700);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ConePainter extends CustomPainter {
  final Color primaryColor;
  final Color textColor;

  ConePainter({required this.primaryColor, required this.textColor});

  @override
  void paint(Canvas canvas, Size size) {
    final apex = Offset(size.width / 2, size.height * 0.18);
    final baseCenter = Offset(size.width / 2, size.height * 0.78);
    final rx = size.width * 0.32;
    final ry = size.height * 0.12;

    // Fill path
    final path = Path()
      ..moveTo(apex.dx, apex.dy)
      ..lineTo(baseCenter.dx - rx, baseCenter.dy)
      ..arcTo(
        Rect.fromCenter(center: baseCenter, width: rx * 2, height: ry * 2),
        math.pi,
        -math.pi,
        false,
      )
      ..close();

    final fillPaint = Paint()
      ..color = primaryColor.withOpacity(0.15);
    canvas.drawPath(path, fillPaint);

    // Base ellipse
    final strokePaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawOval(
      Rect.fromCenter(center: baseCenter, width: rx * 2, height: ry * 2),
      strokePaint,
    );

    // Cone sides
    canvas.drawLine(apex, Offset(baseCenter.dx - rx, baseCenter.dy), strokePaint);
    canvas.drawLine(apex, Offset(baseCenter.dx + rx, baseCenter.dy), strokePaint);

    // Height vertical line (h)
    final hPaint = Paint()
      ..color = Colors.orange.shade700
      ..strokeWidth = 1.5;
    canvas.drawLine(apex, baseCenter, hPaint);

    // Radius line (r)
    final rPaint = Paint()
      ..color = Colors.amber.shade700
      ..strokeWidth = 2.0;
    canvas.drawLine(baseCenter, Offset(baseCenter.dx + rx, baseCenter.dy), rPaint);

    // Text labels
    _drawText(canvas, 'h', Offset(baseCenter.dx - 16, (apex.dy + baseCenter.dy) / 2), Colors.orange.shade700);
    _drawText(canvas, 'r', Offset(baseCenter.dx + rx / 2, baseCenter.dy + 4), Colors.amber.shade700);
    _drawText(canvas, 'l', Offset(baseCenter.dx + rx / 2 + 16, (apex.dy + baseCenter.dy) / 2), primaryColor);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CubePainter extends CustomPainter {
  final Color primaryColor;
  final Color textColor;

  CubePainter({required this.primaryColor, required this.textColor});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final s = math.min(size.width, size.height) * 0.28;

    // Isometric Cube vertices
    final vCenter = Offset(cx, cy);
    final vTop = Offset(cx, cy - s);
    final vBottom = Offset(cx, cy + s);
    final vTopRight = Offset(cx + s * 0.866, cy - s * 0.5);
    final vRight = Offset(cx + s * 0.866, cy + s * 0.5);
    final vTopLeft = Offset(cx - s * 0.866, cy - s * 0.5);
    final vLeft = Offset(cx - s * 0.866, cy + s * 0.5);

    // Top face
    final topPath = Path()..moveTo(vCenter.dx, vCenter.dy)..lineTo(vTopRight.dx, vTopRight.dy)..lineTo(vTop.dx, vTop.dy)..lineTo(vTopLeft.dx, vTopLeft.dy)..close();
    // Left face
    final leftPath = Path()..moveTo(vCenter.dx, vCenter.dy)..lineTo(vTopLeft.dx, vTopLeft.dy)..lineTo(vLeft.dx, vLeft.dy)..lineTo(vBottom.dx, vBottom.dy)..close();
    // Right face
    final rightPath = Path()..moveTo(vCenter.dx, vCenter.dy)..lineTo(vTopRight.dx, vTopRight.dy)..lineTo(vRight.dx, vRight.dy)..lineTo(vBottom.dx, vBottom.dy)..close();

    canvas.drawPath(topPath, Paint()..color = primaryColor.withOpacity(0.3));
    canvas.drawPath(leftPath, Paint()..color = primaryColor.withOpacity(0.15));
    canvas.drawPath(rightPath, Paint()..color = primaryColor.withOpacity(0.22));

    final stroke = Paint()..color = primaryColor..style = PaintingStyle.stroke..strokeWidth = 2.5;
    canvas.drawPath(topPath, stroke);
    canvas.drawPath(leftPath, stroke);
    canvas.drawPath(rightPath, stroke);

    _drawText(canvas, 'a', Offset(cx - s * 0.5, cy + s * 0.6), Colors.amber.shade700);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CylinderPainter extends CustomPainter {
  final Color primaryColor;
  final Color textColor;

  CylinderPainter({required this.primaryColor, required this.textColor});

  @override
  void paint(Canvas canvas, Size size) {
    final topCenter = Offset(size.width / 2, size.height * 0.25);
    final bottomCenter = Offset(size.width / 2, size.height * 0.75);
    final rx = size.width * 0.28;
    final ry = size.height * 0.10;

    final fillPath = Path()
      ..addOval(Rect.fromCenter(center: topCenter, width: rx * 2, height: ry * 2))
      ..addRect(Rect.fromLTRB(topCenter.dx - rx, topCenter.dy, topCenter.dx + rx, bottomCenter.dy))
      ..addOval(Rect.fromCenter(center: bottomCenter, width: rx * 2, height: ry * 2));
    canvas.drawPath(fillPath, Paint()..color = primaryColor.withOpacity(0.15));

    final stroke = Paint()..color = primaryColor..style = PaintingStyle.stroke..strokeWidth = 2.5;
    canvas.drawOval(Rect.fromCenter(center: topCenter, width: rx * 2, height: ry * 2), stroke);
    canvas.drawOval(Rect.fromCenter(center: bottomCenter, width: rx * 2, height: ry * 2), stroke);
    canvas.drawLine(Offset(topCenter.dx - rx, topCenter.dy), Offset(bottomCenter.dx - rx, bottomCenter.dy), stroke);
    canvas.drawLine(Offset(topCenter.dx + rx, topCenter.dy), Offset(bottomCenter.dx + rx, bottomCenter.dy), stroke);

    // Height & Radius
    canvas.drawLine(topCenter, Offset(topCenter.dx + rx, topCenter.dy), Paint()..color = Colors.amber.shade700..strokeWidth = 2);
    _drawText(canvas, 'r', Offset(topCenter.dx + rx / 2, topCenter.dy - 16), Colors.amber.shade700);
    _drawText(canvas, 'h', Offset(bottomCenter.dx + rx + 10, (topCenter.dy + bottomCenter.dy) / 2 - 8), Colors.orange.shade700);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CuboidPainter extends CustomPainter {
  final Color primaryColor;
  final Color textColor;

  CuboidPainter({required this.primaryColor, required this.textColor});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final lx = size.width * 0.28;
    final wx = size.width * 0.18;
    final h = size.height * 0.32;

    final pTopFront = Offset(cx, cy - h / 2);
    final pTopRight = Offset(cx + lx, cy - h / 2 - wx * 0.4);
    final pTopBack = Offset(cx + lx - wx, cy - h / 2 - wx * 0.8);
    final pTopLeft = Offset(cx - wx, cy - h / 2 - wx * 0.4);

    final pBotFront = Offset(cx, cy + h / 2);
    final pBotRight = Offset(cx + lx, cy + h / 2 - wx * 0.4);
    final pBotLeft = Offset(cx - wx, cy + h / 2 - wx * 0.4);

    final pathFront = Path()..moveTo(pTopLeft.dx, pTopLeft.dy)..lineTo(pTopFront.dx, pTopFront.dy)..lineTo(pBotFront.dx, pBotFront.dy)..lineTo(pBotLeft.dx, pBotLeft.dy)..close();
    final pathRight = Path()..moveTo(pTopFront.dx, pTopFront.dy)..lineTo(pTopRight.dx, pTopRight.dy)..lineTo(pBotRight.dx, pBotRight.dy)..lineTo(pBotFront.dx, pBotFront.dy)..close();

    canvas.drawPath(pathFront, Paint()..color = primaryColor.withOpacity(0.18));
    canvas.drawPath(pathRight, Paint()..color = primaryColor.withOpacity(0.28));

    final stroke = Paint()..color = primaryColor..style = PaintingStyle.stroke..strokeWidth = 2.5;
    canvas.drawPath(pathFront, stroke);
    canvas.drawPath(pathRight, stroke);
    canvas.drawLine(pTopFront, pTopRight, stroke);
    canvas.drawLine(pTopRight, pTopBack, stroke);
    canvas.drawLine(pTopBack, pTopLeft, stroke);

    _drawText(canvas, 'l', Offset((pTopLeft.dx + pTopFront.dx) / 2 - 10, (pTopLeft.dy + pTopFront.dy) / 2 - 16), Colors.amber.shade700);
    _drawText(canvas, 'w', Offset((pTopFront.dx + pTopRight.dx) / 2 + 6, (pTopFront.dy + pTopRight.dy) / 2 - 16), Colors.indigo.shade300);
    _drawText(canvas, 'h', Offset(pBotRight.dx + 8, (pTopRight.dy + pBotRight.dy) / 2 - 8), Colors.orange.shade700);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CapsulePainter extends CustomPainter {
  final Color primaryColor;
  final Color textColor;

  CapsulePainter({required this.primaryColor, required this.textColor});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.22;
    final ch = size.height * 0.32;

    final topDomeCenter = Offset(cx, cy - ch / 2);
    final botDomeCenter = Offset(cx, cy + ch / 2);

    final path = Path()
      ..arcTo(Rect.fromCircle(center: topDomeCenter, radius: r), math.pi, math.pi, false)
      ..lineTo(cx + r, botDomeCenter.dy)
      ..arcTo(Rect.fromCircle(center: botDomeCenter, radius: r), 0, math.pi, false)
      ..lineTo(cx - r, topDomeCenter.dy)
      ..close();

    canvas.drawPath(path, Paint()..color = primaryColor.withOpacity(0.18));

    final stroke = Paint()..color = primaryColor..style = PaintingStyle.stroke..strokeWidth = 2.5;
    canvas.drawPath(path, stroke);

    // Dotted lines separating domes
    final dot = Paint()..color = primaryColor.withOpacity(0.5)..style = PaintingStyle.stroke..strokeWidth = 1.5;
    canvas.drawOval(Rect.fromCenter(center: topDomeCenter, width: r * 2, height: r * 0.5), dot);
    canvas.drawOval(Rect.fromCenter(center: botDomeCenter, width: r * 2, height: r * 0.5), dot);

    // Labels
    _drawText(canvas, 'r', Offset(topDomeCenter.dx + r / 2, topDomeCenter.dy - 14), Colors.amber.shade700);
    _drawText(canvas, 'h', Offset(cx + r + 10, cy - 8), Colors.orange.shade700);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SphericalCapPainter extends CustomPainter {
  final Color primaryColor;
  final Color textColor;

  SphericalCapPainter({required this.primaryColor, required this.textColor});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height * 0.65;
    final R = size.height * 0.38;
    final h = R * 0.6;

    final baseCenter = Offset(cx, cy - R + h);

    // Cap arc path
    final path = Path()
      ..addArc(Rect.fromCircle(center: Offset(cx, cy), radius: R), -math.pi * 0.75, math.pi * 0.5);

    canvas.drawCircle(Offset(cx, cy), R, Paint()..color = primaryColor.withOpacity(0.08));
    canvas.drawPath(path, Paint()..color = primaryColor.withOpacity(0.25));

    final stroke = Paint()..color = primaryColor..style = PaintingStyle.stroke..strokeWidth = 2.5;
    canvas.drawCircle(Offset(cx, cy), R, Paint()..color = primaryColor.withOpacity(0.4)..style = PaintingStyle.stroke..strokeWidth = 1.2);
    canvas.drawOval(Rect.fromCenter(center: baseCenter, width: R * 1.5, height: R * 0.4), stroke);

    _drawText(canvas, 'R', Offset(cx - R * 0.4, cy - R * 0.3), Colors.indigo.shade300);
    _drawText(canvas, 'h', Offset(cx + 8, baseCenter.dy - h / 2), Colors.orange.shade700);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class FrustumPainter extends CustomPainter {
  final Color primaryColor;
  final Color textColor;

  FrustumPainter({required this.primaryColor, required this.textColor});

  @override
  void paint(Canvas canvas, Size size) {
    final topCenter = Offset(size.width / 2, size.height * 0.25);
    final botCenter = Offset(size.width / 2, size.height * 0.75);
    final tr = size.width * 0.18;
    final br = size.width * 0.34;
    final ry = size.height * 0.08;

    final path = Path()
      ..moveTo(topCenter.dx - tr, topCenter.dy)
      ..lineTo(botCenter.dx - br, botCenter.dy)
      ..arcTo(Rect.fromCenter(center: botCenter, width: br * 2, height: ry * 2), math.pi, -math.pi, false)
      ..lineTo(topCenter.dx + tr, topCenter.dy)
      ..close();

    canvas.drawPath(path, Paint()..color = primaryColor.withOpacity(0.18));

    final stroke = Paint()..color = primaryColor..style = PaintingStyle.stroke..strokeWidth = 2.5;
    canvas.drawOval(Rect.fromCenter(center: topCenter, width: tr * 2, height: ry * 2), stroke);
    canvas.drawOval(Rect.fromCenter(center: botCenter, width: br * 2, height: ry * 2), stroke);
    canvas.drawLine(Offset(topCenter.dx - tr, topCenter.dy), Offset(botCenter.dx - br, botCenter.dy), stroke);
    canvas.drawLine(Offset(topCenter.dx + tr, topCenter.dy), Offset(botCenter.dx + br, botCenter.dy), stroke);

    _drawText(canvas, 'r', Offset(topCenter.dx + tr / 2, topCenter.dy - 14), Colors.amber.shade700);
    _drawText(canvas, 'R', Offset(botCenter.dx + br / 2, botCenter.dy + 4), Colors.amber.shade800);
    _drawText(canvas, 'h', Offset(botCenter.dx + br + 8, (topCenter.dy + botCenter.dy) / 2), Colors.orange.shade700);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class EllipsoidPainter extends CustomPainter {
  final Color primaryColor;
  final Color textColor;

  EllipsoidPainter({required this.primaryColor, required this.textColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final ax = size.width * 0.36;
    final ay = size.height * 0.24;

    final fillPaint = Paint()..color = primaryColor.withOpacity(0.18);
    canvas.drawOval(Rect.fromCenter(center: center, width: ax * 2, height: ay * 2), fillPaint);

    final stroke = Paint()..color = primaryColor..style = PaintingStyle.stroke..strokeWidth = 2.5;
    canvas.drawOval(Rect.fromCenter(center: center, width: ax * 2, height: ay * 2), stroke);

    // Inner cross ellipses for 3D depth
    final dot = Paint()..color = primaryColor.withOpacity(0.5)..style = PaintingStyle.stroke..strokeWidth = 1.5;
    canvas.drawOval(Rect.fromCenter(center: center, width: ax * 2, height: ay * 0.6), dot);

    // Axes
    _drawText(canvas, 'a', Offset(center.dx + ax / 2, center.dy - 14), Colors.amber.shade700);
    _drawText(canvas, 'b', Offset(center.dx + 8, center.dy - ay / 2), Colors.orange.shade700);
    _drawText(canvas, 'c', Offset(center.dx - ax * 0.4, center.dy + ay * 0.3), Colors.teal.shade300);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

void _drawText(Canvas canvas, String text, Offset position, Color color) {
  final textPainter = TextPainter(
    text: TextSpan(
      text: text,
      style: TextStyle(
        color: color,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    ),
    textDirection: TextDirection.ltr,
  );
  textPainter.layout();
  textPainter.paint(canvas, position);
}
