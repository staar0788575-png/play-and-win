import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/app_sizes.dart';

enum BadgeType { primary, success, warning, error, info, accent }

class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.label,
    this.type = BadgeType.primary,
    this.icon,
  });

  final String label;
  final BadgeType type;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = _getColors(type);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colors.$2,
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: colors.$1),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colors.$1,
            ),
          ),
        ],
      ),
    );
  }

  (Color, Color) _getColors(BadgeType type) {
    return switch (type) {
      BadgeType.primary => (AppColors.primary, AppColors.primaryContainer),
      BadgeType.success => (AppColors.success, AppColors.successContainer),
      BadgeType.warning => (AppColors.warning, AppColors.warningContainer),
      BadgeType.error => (AppColors.error, AppColors.errorContainer),
      BadgeType.info => (AppColors.secondary, AppColors.secondaryContainer),
      BadgeType.accent => (AppColors.accentDark, AppColors.accentContainer),
    };
  }
}

class PointsBadge extends StatelessWidget {
  const PointsBadge({
    super.key,
    required this.points,
    this.size = 16,
  });

  final int points;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: AppColors.accentGradient,
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.stars, size: size, color: AppColors.onAccent),
          const SizedBox(width: 4),
          Text(
            points.toString(),
            style: TextStyle(
              fontSize: size - 2,
              fontWeight: FontWeight.w700,
              color: AppColors.onAccent,
            ),
          ),
        ],
      ),
    );
  }
}
