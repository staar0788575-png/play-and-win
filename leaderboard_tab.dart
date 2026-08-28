import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/app_sizes.dart';
import '../../core/widgets/avatars.dart';
import '../../core/widgets/loading.dart';
import '../../core/utils/formatters.dart';
import '../providers/game_provider.dart';

class LeaderboardTab extends StatefulWidget {
  const LeaderboardTab({super.key});

  @override
  State<LeaderboardTab> createState() => _LeaderboardTabState();
}

class _LeaderboardTabState extends State<LeaderboardTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GameProvider>().loadLeaderboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard')),
      body: Consumer<GameProvider>(
        builder: (context, provider, _) {
          if (provider.leaderboard.isEmpty) {
            return const EmptyState(
              icon: Icons.leaderboard,
              title: 'No Rankings Yet',
              subtitle: 'Play tournaments to appear on the leaderboard',
            );
          }

          final top3 = provider.leaderboard.take(3).toList();
          final rest = provider.leaderboard.skip(3).toList();

          return ListView(
            padding: const EdgeInsets.all(AppSizes.md),
            children: [
              _buildPodium(context, top3),
              const SizedBox(height: AppSizes.lg),
              ...rest.map((e) => _buildRankTile(context, e)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPodium(BuildContext context, List entries) {
    if (entries.length < 3) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _podiumColumn(context, entries[1], 2, 100, Colors.grey.shade400),
        _podiumColumn(context, entries[0], 1, 130, const Color(0xFFFFD700)),
        _podiumColumn(context, entries[2], 3, 80, const Color(0xFFCD7F32)),
      ],
    );
  }

  Widget _podiumColumn(
    BuildContext context,
    dynamic entry,
    int rank,
    double height,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          UserAvatar(
            imageUrl: entry.avatarUrl,
            name: entry.username,
            size: rank == 1 ? 64 : 52,
            showRing: true,
            ringColor: color,
          ),
          const SizedBox(height: 8),
          Text(entry.username,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  )),
          Text('${entry.totalPoints} pts',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.neutral50,
                  )),
          const SizedBox(height: 8),
          Container(
            width: 70,
            height: height,
            decoration: BoxDecoration(
              color: color.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color, width: 2),
            ),
            child: Center(
              child: Text('#$rank',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: color,
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankTile(BuildContext context, dynamic entry) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.neutral30
              : AppColors.neutral90,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Text('#${entry.rank}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.neutral50,
                    )),
          ),
          const SizedBox(width: 12),
          UserAvatar(imageUrl: entry.avatarUrl, name: entry.username, size: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.username,
                    style: Theme.of(context).textTheme.titleMedium),
                Text('${entry.tournamentsWon} wins · ${Formatters.percentage(entry.winRate)} win rate',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.neutral50,
                        )),
              ],
            ),
          ),
          Text('${entry.totalPoints}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.accentDark,
                  )),
        ],
      ),
    );
  }
}
