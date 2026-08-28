import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/widgets/cards.dart';
import '../../core/widgets/loading.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/app_sizes.dart';
import '../../data/models/tournament_model.dart';
import '../providers/game_provider.dart';
import '../widgets/tournament_card.dart';
import 'tournament_detail_screen.dart';

class TournamentsTab extends StatelessWidget {
  const TournamentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tournaments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<GameProvider>(
        builder: (context, provider, _) {
          if (provider.tournaments.isEmpty) {
            return const EmptyState(
              icon: Icons.sports_esports,
              title: 'No Tournaments Yet',
              subtitle: 'Check back soon for exciting competitions!',
            );
          }

          final live = provider.liveTournaments;
          final upcoming = provider.upcomingTournaments;

          return ListView(
            padding: const EdgeInsets.all(AppSizes.md),
            children: [
              if (live.isNotEmpty) ...[
                const SectionHeader(title: 'Live Now', subtitle: 'Join before it\'s too late'),
                const SizedBox(height: AppSizes.md),
                ...live.map((t) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSizes.md),
                      child: TournamentCard(
                        tournament: t,
                        onTap: () => _openDetail(context, t),
                      ),
                    )),
              ],
              if (upcoming.isNotEmpty) ...[
                const SizedBox(height: AppSizes.lg),
                const SectionHeader(title: 'Upcoming', subtitle: 'Register to secure your spot'),
                const SizedBox(height: AppSizes.md),
                ...upcoming.map((t) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSizes.md),
                      child: TournamentCard(
                        tournament: t,
                        onTap: () => _openDetail(context, t),
                      ),
                    )),
              ],
            ],
          );
        },
      ),
    );
  }

  void _openDetail(BuildContext context, TournamentModel tournament) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TournamentDetailScreen(tournament: tournament),
      ),
    );
  }
}
