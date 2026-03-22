import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../../app_config.dart';

class BetaModePalette {
  BetaModePalette._();

  static const Color ribbon = Color(0xFF2F6B57);
  static const Color ribbonText = Color(0xFFF8FAF7);
  static const Color chipBackground = Color(0xFFE8F3EE);
  static const Color chipBorder = Color(0xFF9DBDAF);
  static const Color chipText = Color(0xFF2E5E4E);
  static const Color helperBackground = Color(0xFFF3F8F5);
  static const Color helperBorder = Color(0xFFD3E4DA);
  static const Color helperText = Color(0xFF5F746A);
  static const Color dialogAccent = Color(0xFFC59A3D);
}

class BetaModeNoticeStore {
  BetaModeNoticeStore._();

  static final GetStorage _storage = GetStorage();

  static String _todayKey() {
    final now = DateTime.now();
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    return '${now.year}-$month-$day';
  }

  static bool shouldShowToday() {
    final hiddenDate = _storage.read<String>(StorageKeys.betaNoticeHiddenDate);
    return hiddenDate != _todayKey();
  }

  static Future<void> hideForToday() {
    return _storage.write(StorageKeys.betaNoticeHiddenDate, _todayKey());
  }
}

class BetaModeRibbon extends StatelessWidget {
  const BetaModeRibbon({super.key, required this.enabled, required this.child});

  final bool enabled;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;
    return Banner(
      message: 'BETA',
      location: BannerLocation.topEnd,
      color: BetaModePalette.ribbon,
      textStyle: const TextStyle(
        color: BetaModePalette.ribbonText,
        fontWeight: FontWeight.w900,
        fontSize: 11,
        letterSpacing: 0.8,
      ),
      child: child,
    );
  }
}

class BetaModeStatusChip extends StatelessWidget {
  const BetaModeStatusChip({super.key, this.label = '베타 · 6개 한정'});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: BetaModePalette.chipBackground,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: BetaModePalette.chipBorder),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: BetaModePalette.chipText,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class BetaModeHelperText extends StatelessWidget {
  const BetaModeHelperText({
    super.key,
    required this.text,
    this.compact = false,
  });

  final String text;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, compact ? 8 : 12, 16, compact ? 0 : 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: BetaModePalette.helperBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BetaModePalette.helperBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 1),
            child: Icon(
              Icons.info_outline_rounded,
              size: 16,
              color: BetaModePalette.chipText,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: BetaModePalette.helperText,
                fontWeight: FontWeight.w600,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
