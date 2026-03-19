import 'package:flutter/material.dart';

import '../../core/design_token.dart';

/// 관리자 맵 플레이스홀더
class AdminMapPlaceholder extends StatelessWidget {
  const AdminMapPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 256,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE2E8F0), Color(0xFFCBD5E1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: DesignToken.primary.withValues(alpha: 0.2)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _MapPatternPainter())),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.map_outlined,
                  size: 48,
                  color: Colors.blueGrey.shade300,
                ),
                const SizedBox(height: 8),
                Text(
                  '강남구 재배치 시각화 맵',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: const Color(0xFF475569),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MapPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.40)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final pointPaint = Paint()
      ..color = DesignToken.primary.withValues(alpha: 0.28)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width * 0.08, size.height * 0.75)
      ..quadraticBezierTo(
        size.width * 0.24,
        size.height * 0.30,
        size.width * 0.50,
        size.height * 0.48,
      )
      ..quadraticBezierTo(
        size.width * 0.72,
        size.height * 0.64,
        size.width * 0.90,
        size.height * 0.20,
      );
    canvas.drawPath(path, linePaint);

    for (final offset in <Offset>[
      Offset(size.width * 0.14, size.height * 0.64),
      Offset(size.width * 0.31, size.height * 0.42),
      Offset(size.width * 0.48, size.height * 0.50),
      Offset(size.width * 0.69, size.height * 0.57),
      Offset(size.width * 0.84, size.height * 0.31),
    ]) {
      canvas.drawCircle(offset, 10, pointPaint);
      canvas.drawCircle(offset, 4, Paint()..color = DesignToken.primary);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
