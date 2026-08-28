import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/app_sizes.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.size = AppSizes.avatarMd,
    this.showRing = false,
    this.ringColor,
  });

  final String? imageUrl;
  final String? name;
  final double size;
  final bool showRing;
  final Color? ringColor;

  @override
  Widget build(BuildContext context) {
    final initials = _getInitials(name);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget avatar;
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      avatar = ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: Image.network(
          imageUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildPlaceholder(initials, size),
        ),
      );
    } else {
      avatar = _buildPlaceholder(initials, size);
    }

    if (showRing) {
      return Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: ringColor ?? AppColors.secondary,
            width: 2,
          ),
        ),
        child: avatar,
      );
    }

    return avatar;
  }

  Widget _buildPlaceholder(String initials, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.primaryGradient,
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.4,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}

class RankBadge extends StatelessWidget {
  const RankBadge({
    super.key,
    required this.rank,
    this.size = 40,
  });

  final int rank;
  final double size;

  @override
  Widget build(BuildContext context) {
    final (color, icon) = _getRankStyle(rank);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: rank <= 3
            ? Icon(icon, color: Colors.white, size: size * 0.5)
            : Text(
                rank.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size * 0.4,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }

  (Color, IconData) _getRankStyle(int rank) {
    return switch (rank) {
      1 => (const Color(0xFFFFD700), Icons.emoji_events),
      2 => (const Color(0xFFC0C0C0), Icons.emoji_events),
      3 => (const Color(0xFFCD7F32), Icons.emoji_events),
      _ => (AppColors.primary, Icons.looks),
    };
  }
}
