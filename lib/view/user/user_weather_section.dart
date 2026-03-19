// DDRI 날씨: 주간 예보, 선택 시각 상세, /v1/weather 연동
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/api/models/station_models.dart';
import '../../core/design_token.dart';
import '../../vm/user_page_controller.dart';

/// 주간 날씨 + 선택 시각 날씨. 재시도 버튼 포함.
class UserWeatherSection extends StatelessWidget {
  const UserWeatherSection({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<UserPageController>();

    return Obx(() {
      if (!ctrl.hasLocation) return const SizedBox.shrink();
      if (ctrl.isLoadingWeather.value && ctrl.weeklyForecast.isEmpty) {
        return const Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        );
      }
      if (ctrl.weatherErrorMessage.value.isNotEmpty &&
          ctrl.weeklyForecast.isEmpty &&
          ctrl.selectedForecast.value == null) {
        return Container(
          margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: DesignToken.cardBackground,
            borderRadius: BorderRadius.circular(DesignToken.cardRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  ctrl.weatherErrorMessage.value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              IconButton(
                onPressed: ctrl.isLoadingWeather.value ? null : ctrl.retryWeather,
                icon: const Icon(Icons.refresh),
                tooltip: '날씨 재시도',
              ),
            ],
          ),
        );
      }
      if (ctrl.weeklyForecast.isEmpty && ctrl.selectedForecast.value == null) {
        return const SizedBox.shrink();
      }

      return Container(
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: DesignToken.cardBackground,
          borderRadius: BorderRadius.circular(DesignToken.cardRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '이번 주 날씨',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final crossAxisCount = width >= 1100
                    ? 7
                    : width >= 700
                        ? 4
                        : 4;
                final mainAxisExtent = width >= 1100
                    ? 176.0
                    : width >= 700
                        ? 182.0
                        : width >= DesignToken.breakpointTablet
                            ? 150.0
                            : 140.0;

                final compact = width < DesignToken.breakpointTablet;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: ctrl.weeklyForecast.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: compact ? 6 : 10,
                    mainAxisSpacing: compact ? 6 : 10,
                    mainAxisExtent: mainAxisExtent,
                  ),
                  itemBuilder: (_, index) {
                    final item = ctrl.weeklyForecast[index];
                    return _WeeklyWeatherCard(item: item, compact: compact);
                  },
                );
              },
            ),
            if (ctrl.selectedForecast.value != null) ...[
              const SizedBox(height: 16),
              Text(
                '선택 시간 예상 날씨',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 8),
              _SelectedWeatherCard(item: ctrl.selectedForecast.value!),
            ],
          ],
        ),
      );
    });
  }
}

class _WeeklyWeatherCard extends StatelessWidget {
  const _WeeklyWeatherCard({required this.item, this.compact = false});

  final WeatherDayItem item;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final date = DateTime.tryParse(item.weatherDatetime);
    final weekday = date == null ? '' : _weekdayLabel(date.weekday);
    final label = date == null ? item.weatherDatetime : '$weekday ${date.month}/${date.day}';
    final dateColor = date == null ? Colors.grey.shade700 : _weekdayColor(date.weekday);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 10,
        vertical: compact ? 6 : 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(compact ? 8 : 12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: dateColor,
                  fontWeight: FontWeight.w700,
                  fontSize: compact ? 11 : null,
                ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: compact ? 4 : 8),
          Icon(
            _weatherIcon(item.weatherType),
            color: _weatherColor(item.weatherType),
            size: compact ? 24 : 36,
          ),
          SizedBox(height: compact ? 2 : 8),
          Text(
            item.weatherType,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: compact ? 11 : null,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: compact ? 2 : 6),
          Text(
            '${item.weatherLow.toStringAsFixed(0)}°/${item.weatherHigh.toStringAsFixed(0)}°',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w700,
                  fontSize: compact ? 11 : null,
                ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (compact) const SizedBox(height: 2),
          Text(
            '강수 ${item.precipitationProbability.toStringAsFixed(0)}%',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.blueGrey.shade700,
                  fontWeight: FontWeight.w600,
                  fontSize: compact ? 10 : null,
                ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _SelectedWeatherCard extends StatelessWidget {
  const _SelectedWeatherCard({required this.item});

  final WeatherDayItem item;

  @override
  Widget build(BuildContext context) {
    final dt = DateTime.tryParse(item.weatherDatetime);
    final label = dt == null
        ? item.weatherDatetime
        : '${dt.month}/${dt.day} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: DesignToken.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: DesignToken.primary.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          Icon(
            _weatherIcon(item.weatherType),
            color: _weatherColor(item.weatherType),
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade700,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.weatherType,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  '강수 ${item.precipitationProbability.toStringAsFixed(0)}%',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.blueGrey.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                if (item.temperature != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    '현재 예상 ${item.temperature!.toStringAsFixed(0)}°',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ],
            ),
          ),
          Text(
            '${item.weatherLow.toStringAsFixed(0)}° / ${item.weatherHigh.toStringAsFixed(0)}°',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}

IconData _weatherIcon(String type) {
  if (type.contains('비')) return Icons.umbrella;
  if (type.contains('눈')) return Icons.ac_unit;
  if (type.contains('흐림') || type.contains('구름')) return Icons.cloud;
  return Icons.wb_sunny;
}

Color _weatherColor(String type) {
  if (type.contains('비')) return Colors.blue;
  if (type.contains('눈')) return Colors.lightBlue;
  if (type.contains('흐림') || type.contains('구름')) return Colors.blueGrey;
  return Colors.orange;
}

String _weekdayLabel(int weekday) {
  switch (weekday) {
    case DateTime.monday:
      return '월';
    case DateTime.tuesday:
      return '화';
    case DateTime.wednesday:
      return '수';
    case DateTime.thursday:
      return '목';
    case DateTime.friday:
      return '금';
    case DateTime.saturday:
      return '토';
    case DateTime.sunday:
      return '일';
    default:
      return '';
  }
}

Color _weekdayColor(int weekday) {
  if (weekday == DateTime.saturday) return Colors.blue.shade700;
  if (weekday == DateTime.sunday) return Colors.red.shade700;
  return Colors.grey.shade700;
}
