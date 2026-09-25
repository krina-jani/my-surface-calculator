import 'package:flutter/material.dart';

/// Renders authentic Instagram vector logo badge with glowing shadow
class InstagramLogoWidget extends StatelessWidget {
  final double size;
  const InstagramLogoWidget({super.key, this.size = 46});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF833AB4),
            Color(0xFFFD1D1D),
            Color(0xFFFCAF45),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE1306C).withOpacity(0.45),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: SizedBox(
          width: size * 0.6,
          height: size * 0.6,
          child: CustomPaint(
            painter: _InstagramGlyphPainter(),
          ),
        ),
      ),
    );
  }
}

class _InstagramGlyphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final strokeWidth = size.width * 0.11;
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    // Outer RRect
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(size.width * 0.28));
    canvas.drawRRect(rrect, paint);

    // Inner Center Circle
    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, size.width * 0.24, paint);

    // Top Right Dot
    final dotPaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(size.width * 0.72, size.height * 0.28), size.width * 0.08, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Renders authentic LinkedIn vector logo badge with glowing shadow
class LinkedInLogoWidget extends StatelessWidget {
  final double size;
  const LinkedInLogoWidget({super.key, this.size = 46});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        color: const Color(0xFF0A66C2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0A66C2).withOpacity(0.45),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          'in',
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.58,
            fontWeight: FontWeight.w900,
            fontFamily: 'sans-serif',
            height: 1.0,
          ),
        ),
      ),
    );
  }
}

/// Renders Phone / Contact Us icon badge with green gradient and glowing shadow
class ContactUsLogoWidget extends StatelessWidget {
  final double size;
  const ContactUsLogoWidget({super.key, this.size = 46});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF22C55E),
            Color(0xFF16A34A),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF22C55E).withOpacity(0.45),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        Icons.phone_rounded,
        color: Colors.white,
        size: size * 0.55,
      ),
    );
  }
}

/// Renders authentic Facebook vector logo badge with glowing shadow
class FacebookLogoWidget extends StatelessWidget {
  final double size;
  const FacebookLogoWidget({super.key, this.size = 46});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        color: const Color(0xFF1877F2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1877F2).withOpacity(0.45),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          'f',
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.65,
            fontWeight: FontWeight.w900,
            fontFamily: 'sans-serif',
            height: 1.0,
          ),
        ),
      ),
    );
  }
}
