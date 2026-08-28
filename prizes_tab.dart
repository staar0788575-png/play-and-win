import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/app_sizes.dart';
import '../../core/widgets/badges.dart';
import '../../core/widgets/cards.dart';
import '../../data/models/prize_model.dart';
import '../providers/prize_provider.dart';
import '../providers/auth_provider.dart';
import 'prize_detail_screen.dart';

class PrizesTab extends StatelessWidget {
  const PrizesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prize Shop'),
        actions: [
          Consumer<AuthProvider>(
            builder: (context, auth, _) {
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: PointsBadge(points: auth.userModel?.totalPoints ?? 0),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<PrizeProvider>(
        builder: (context, provider, _) {
          if (provider.prizes.isEmpty) {
            return const EmptyState(
              icon: Icons.card_giftcard,
              title: 'No Prizes Available',
              subtitle: 'Check back later for new rewards!',
            );
          }

          return ListView(
            padding: const EdgeInsets.all(AppSizes.md),
            children: [
              if (provider.giftCards.isNotEmpty) ...[
                const SectionHeader(title: 'Gift Cards'),
                const SizedBox(height: AppSizes.md),
                ...provider.giftCards.map((p) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSizes.md),
                      child: _PrizeCard(prize: p, onTap: () => _open(context, p)),
                    )),
              ],
              if (provider.mobileTopUps.isNotEmpty) ...[
                const SizedBox(height: AppSizes.lg),
                const SectionHeader(title: 'Mobile Top-Ups'),
                const SizedBox(height: AppSizes.md),
                ...provider.mobileTopUps.map((p) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSizes.md),
                      child: _PrizeCard(prize: p, onTap: () => _open(context, p)),
                    )),
              ],
            ],
          );
        },
      ),
    );
  }

  void _open(BuildContext context, PrizeModel prize) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PrizeDetailScreen(prize: prize)),
    );
  }
}

class _PrizeCard extends StatelessWidget {
  const _PrizeCard({required this.prize, this.onTap});

  final PrizeModel prize;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: AppColors.accentGradient,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: Icon(
              prize.type == PrizeType.giftCard
                  ? Icons.card_giftcard
                  : Icons.phone_android,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(prize.name, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 2),
                Text(prize.brand,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.neutral50,
                        )),
              ],
            ),
          ),
          PointsBadge(points: prize.costInPoints),
        ],
      ),
    );
  }
}
