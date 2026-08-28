import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/cards.dart';
import '../../core/widgets/badges.dart';
import '../../core/widgets/avatars.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/app_sizes.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/app_snackbars.dart';
import '../../core/utils/app_dialogs.dart';
import '../../data/models/tournament_model.dart';
import '../providers/auth_provider.dart';
import '../providers/game_provider.dart';
import 'game_room_screen.dart';

class TournamentDetailScreen extends StatelessWidget {
  const TournamentDetailScreen({super.key, required this.tournament});

  final TournamentModel tournament;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tournament Details')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBanner(context),
            Padding(
              padding: const EdgeInsets.all(AppSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tournament.name,
                      style: Theme.of(context).textTheme.displayMedium),
                  const SizedBox(height: 4),
                  Text(tournament.game.name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.neutral50,
                          )),
                  const SizedBox(height: 16),
                  _buildPrizePool(context),
                  const SizedBox(height: 16),
                  _buildInfoGrid(context),
                  const SizedBox(height: 16),
                  _buildRules(context),
                  const SizedBox(height: 24),
                  Consumer<AuthProvider>(
                    builder: (context, auth, _) {
                      return Consumer<GameProvider>(
                        builder: (context, gameProvider, _) {
                          return GradientButton(
                            label: tournament.canRegister
                                ? 'Register Now'
                                : tournament.status == TournamentStatus.live
                                    ? 'Join Room'
                                    : 'View Matches',
                            isLoading: gameProvider.isLoading,
                            onPressed: () =>
                                _handleAction(context, auth, gameProvider),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
      ),
      child: Stack(
        children: [
          Center(
            child: Icon(Icons.sports_esports,
                size: 80, color: Colors.white.withOpacity(0.2)),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: StatusBadge(
              label: _statusLabel(),
              type: _statusType(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrizePool(BuildContext context) {
    return AppCard(
      gradient: AppColors.accentGradient,
      child: Column(
        children: [
          Text('Prize Pool',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onAccent,
                  )),
          const SizedBox(height: 4),
          Text(
            Formatters.currency(tournament.prizePool),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: AppColors.onAccent,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _prizeTier('1st', tournament.firstPrize),
              _prizeTier('2nd', tournament.secondPrize),
              _prizeTier('3rd', tournament.thirdPrize),
            ],
          ),
        ],
      ),
    );
  }

  Widget _prizeTier(String place, double amount) {
    return Column(
      children: [
        Text(place,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.onAccent)),
        Text(Formatters.currency(amount),
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.onAccent)),
      ],
    );
  }

  Widget _buildInfoGrid(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _infoTile(
            context,
            icon: Icons.group,
            label: 'Players',
            value: '${tournament.registeredPlayers}/${tournament.maxPlayers}',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _infoTile(
            context,
            icon: tournament.isFree ? Icons.money_off : Icons.attach_money,
            label: 'Entry Fee',
            value: tournament.isFree ? 'Free' : Formatters.currency(tournament.entryFee),
          ),
        ),
      ],
    );
  }

  Widget _infoTile(BuildContext context,
      {required IconData icon, required String label, required String value}) {
    return AppCard(
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(height: 8),
          Text(value, style: Theme.of(context).textTheme.titleMedium),
          Text(label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.neutral50,
                  )),
        ],
      ),
    );
  }

  Widget _buildRules(BuildContext context) {
    if (tournament.rules == null || tournament.rules!.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Rules', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        ...tournament.rules!.map((rule) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle, size: 18, color: AppColors.success),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(rule,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Future<void> _handleAction(
      BuildContext context, AuthProvider auth, GameProvider gameProvider) async {
    if (tournament.canRegister) {
      final confirmed = await AppDialogs.confirm(
        context,
        title: 'Register for Tournament',
        message: tournament.isFree
            ? 'Do you want to join "${tournament.name}" for free?'
            : 'Do you want to join "${tournament.name}" for ${Formatters.currency(tournament.entryFee)}?',
        confirmText: 'Register',
      );
      if (confirmed == true && auth.userModel != null) {
        final success = await gameProvider.registerForTournament(
            tournament.id, auth.userModel!.id);
        if (success) {
          AppSnackbars.success(context, 'Successfully registered!');
        } else {
          AppSnackbars.error(context, gameProvider.error ?? 'Registration failed');
        }
      }
    } else if (tournament.status == TournamentStatus.live) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => GameRoomScreen(tournament: tournament),
        ),
      );
    }
  }

  String _statusLabel() => switch (tournament.status) {
        TournamentStatus.upcoming => 'UPCOMING',
        TournamentStatus.registration => 'REGISTRATION OPEN',
        TournamentStatus.live => 'LIVE NOW',
        TournamentStatus.completed => 'COMPLETED',
        TournamentStatus.cancelled => 'CANCELLED',
      };

  BadgeType _statusType() => switch (tournament.status) {
        TournamentStatus.upcoming => BadgeType.info,
        TournamentStatus.registration => BadgeType.success,
        TournamentStatus.live => BadgeType.error,
        TournamentStatus.completed => BadgeType.primary,
        TournamentStatus.cancelled => BadgeType.warning,
      };
}
