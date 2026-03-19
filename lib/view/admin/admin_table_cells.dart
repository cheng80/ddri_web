// DDRI 관리자 테이블 셀: 위험도 프로그레스 바, 우선순위 배지
import 'package:flutter/material.dart';

import '../../core/design_token.dart';

/// 위험도 프로그레스 바 + 숫자. 0.7↑ 빨강, 0.5↑ 주황, 그 외 녹색.
Widget buildRiskCell(double riskScore) {
  final color = riskScore >= 0.7
      ? Colors.red
      : riskScore >= 0.5
          ? Colors.orange
          : DesignToken.primary;
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      SizedBox(
        width: 60,
        height: 8,
        child: LinearProgressIndicator(
          value: riskScore.clamp(0.0, 1.0),
          backgroundColor: Colors.grey.shade300,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ),
      const SizedBox(width: 6),
      Text(
        riskScore.toStringAsFixed(2),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: color,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    ],
  );
}

/// 우선순위 원형 배지. 1=빨강, 2=주황, 3+=회색.
Widget buildPriorityBadge(int priority) {
  final color = priority <= 1
      ? Colors.red
      : priority <= 2
          ? Colors.orange
          : Colors.grey;
  return Container(
    width: 28,
    height: 28,
    decoration: BoxDecoration(
      color: color.shade100,
      shape: BoxShape.circle,
    ),
    alignment: Alignment.center,
    child: Text(
      '$priority',
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w900,
        color: color.shade700,
      ),
    ),
  );
}
