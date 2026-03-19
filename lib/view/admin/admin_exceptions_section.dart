// DDRI 예외 스테이션: 실시간 비노출 ID 목록, 접이식
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/design_token.dart';
import '../../vm/admin_page_controller.dart';

/// 예외 스테이션 접이식 영역. exceptions 비어있으면 숨김.
class AdminExceptionsSection extends StatelessWidget {
  const AdminExceptionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<AdminPageController>();

    return Obx(() {
      if (ctrl.exceptions.isEmpty) return const SizedBox.shrink();

      final ids = ctrl.exceptions.map((e) => e.stationId).join(', ');

      return Container(
        decoration: BoxDecoration(
          color: DesignToken.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: DesignToken.primary.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InkWell(
                onTap: ctrl.toggleExceptionsExpanded,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20,
                        color: Colors.orange.shade700,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '예외 스테이션: station_id $ids - 실시간 비노출',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: Colors.orange.shade800,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                      Icon(
                        ctrl.exceptionsExpanded.value
                            ? Icons.expand_less
                            : Icons.expand_more,
                        color: Colors.orange.shade700,
                      ),
                    ],
                  ),
                ),
              ),
              if (ctrl.exceptionsExpanded.value)
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      '해당 스테이션들은 현재 공사 또는 일시 폐쇄 상태로 인해 자동 재배치 알고리즘에서 제외되었습니다. '
                      '현장 확인 후 노출 상태를 변경하시기 바랍니다. 관리자에게만 노출되는 정보입니다.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF64748B),
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }
}
