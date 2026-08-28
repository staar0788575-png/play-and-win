import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/app_sizes.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/badges.dart';
import '../../core/widgets/avatars.dart';
import '../../data/models/tournament_model.dart';

class TournamentCard extends StatelessWidget {
  const TournamentCard({
    super.key,
    required this.tournament,
    this.onTap,
  });

  final TournamentModel tournament;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.lightCard,
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            border: Border.all(
              color: isDark ? AppColors.neutral30 : AppColors.neutral90,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppSizes.radiusLg),
                ),
                child: Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Icon(
                          Icons.sports_esports,
                          size: 48,
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        left: 8,
                        child: StatusBadge(
                          label: _statusLabel(tournament.status),
                          type: _statusType(tournament.status),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            tournament.name,
                            style: Theme.of(context).textTheme.titleLarge,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (tournament.isFree)
                          const StatusBadge(label: 'FREE', type: BadgeType.success)
                        else
                          StatusBadge(
                            label: Formatters.currency(tournament.entryFee),
                            type: BadgeType.accent,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tournament.game.name,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.neutral50,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.group, size: 16, color: AppColors.neutral50),
                        const SizedBox(width: 4),
                        Text(
                          '${tournament.registeredPlayers}/${tournament.maxPlayers}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.neutral50,
                              ),
                        ),
                        const Spacer(),
                        Icon(Icons.emoji_events, size: 16, color: AppColors.accent),
                        const SizedBox(width: 4),
                        Text(
                          Formatters.currency(tournament.prizePool),
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: AppColors.accentDark,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.schedule, size: 16, color: AppColors.neutral50),
                        const SizedBox(width: 4),
                        Text(
                          Formatters.dateTime(tournament.startsAt),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.neutral50,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _statusLabel(TournamentStatus status) {
    return switch (status) {
      TournamentStatus.upcoming => 'UPCOMING',
      TournamentStatus.registration => 'OPEN',
      TournamentStatus.live => 'LIVE',
      TournamentStatus.completed => 'DONE',
      TournamentStatus.cancelled => 'CANCELLED',
    };
  }

  BadgeType _statusType(TournamentStatus status) {
    return switch (status) {
      TournamentStatus.upcoming => BadgeType.info,
      TournamentStatus.registration => BadgeType.success,
      TournamentStatus.live => BadgeType.error,
      TournamentStatus.completed => BadgeType.primary,
      TournamentStatus.cancelled => BadgeType.warning,
    };
  }
}
