import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/app_sizes.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/app_snackbars.dart';
import '../../core/utils/app_dialogs.dart';
import '../../core/widgets/avatars.dart';
import '../../core/widgets/badges.dart';
import '../../core/widgets/cards.dart';
import '../../core/widgets/text_fields.dart';
import '../../core/widgets/buttons.dart';
import '../providers/auth_provider.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editProfile(context),
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          final user = auth.userModel;
          if (user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.all(AppSizes.md),
            children: [
              Center(
                child: Column(
                  children: [
                    UserAvatar(
                      imageUrl: user.avatarUrl,
                      name: user.displayName ?? user.username,
                      size: AppSizes.avatarXl,
                      showRing: true,
                    ),
                    const SizedBox(height: 12),
                    Text(user.displayName ?? user.username,
                        style: Theme.of(context).textTheme.displayMedium),
                    Text('@${user.username}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.neutral50,
                            )),
                    if (user.bio != null) ...[
                      const SizedBox(height: 8),
                      Text(user.bio!,
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.lg),
              _buildStatsGrid(context, user),
              const SizedBox(height: AppSizes.lg),
              const SectionHeader(title: 'Achievements'),
              const SizedBox(height: AppSizes.md),
              _buildAchievements(context, user),
              const SizedBox(height: AppSizes.lg),
              const SectionHeader(title: 'Settings'),
              const SizedBox(height: AppSizes.md),
              _buildSettings(context),
              const SizedBox(height: AppSizes.lg),
              SecondaryButton(
                label: 'Sign Out',
                icon: Icons.logout,
                onPressed: () => _signOut(context),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, dynamic user) {
    return Row(
      children: [
        Expanded(child: _statCard(context, Icons.stars, 'Points', user.totalPoints.toString())),
        const SizedBox(width: 8),
        Expanded(child: _statCard(context, Icons.emoji_events, 'Wins', user.tournamentsWon.toString())),
        const SizedBox(width: 8),
        Expanded(child: _statCard(context, Icons.sports_esports, 'Played', user.tournamentsPlayed.toString())),
      ],
    );
  }

  Widget _statCard(BuildContext context, IconData icon, String label, String value) {
    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 28),
          const SizedBox(height: 8),
          Text(value, style: Theme.of(context).textTheme.titleLarge),
          Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.neutral50,
              )),
        ],
      ),
    );
  }

  Widget _buildAchievements(BuildContext context, dynamic user) {
    final achievements = <(IconData, String, bool)>[
      (Icons.emoji_events, 'First Win', user.tournamentsWon > 0),
      (Icons.local_fire_department, '5 Wins', user.tournamentsWon >= 5),
      (Icons.star, '100 Points', user.totalPoints >= 100),
      (Icons.diamond, '500 Points', user.totalPoints >= 500),
      (Icons.military_tech, '10 Tournaments', user.tournamentsPlayed >= 10),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: achievements.map((a) {
        final (icon, label, unlocked) = a;
        return Container(
          width: 100,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: unlocked
                ? AppColors.accentContainer
                : (Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkSurfaceVariant
                    : AppColors.neutral95),
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            border: Border.all(
              color: unlocked ? AppColors.accent : AppColors.neutral80,
              width: unlocked ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(icon,
                  size: 28,
                  color: unlocked ? AppColors.accentDark : AppColors.neutral50),
              const SizedBox(height: 4),
              Text(label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: unlocked ? AppColors.accentDark : AppColors.neutral50,
                      ),
                  textAlign: TextAlign.center),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSettings(BuildContext context) {
    return Column(
      children: [
        _settingTile(Icons.notifications, 'Notifications', () {}),
        _settingTile(Icons.privacy_tip, 'Privacy & Security', () {}),
        _settingTile(Icons.help, 'Help & Support', () {}),
        _settingTile(Icons.info, 'About', () {}),
      ],
    );
  }

  Widget _settingTile(IconData icon, String label, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: AppCard(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label, style: Theme.of(context).textTheme.bodyLarge),
            ),
            const Icon(Icons.chevron_right, color: AppColors.neutral50),
          ],
        ),
      ),
    );
  }

  Future<void> _editProfile(BuildContext context) async {
    final auth = context.read<AuthProvider>();
    final user = auth.userModel;
    if (user == null) return;

    final nameController = TextEditingController(text: user.displayName ?? user.username);
    final bioController = TextEditingController(text: user.bio ?? '');
    final formKey = GlobalKey<FormState>();

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Profile'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(
                controller: nameController,
                label: 'Display Name',
                prefixIcon: Icons.person,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: bioController,
                label: 'Bio',
                hint: 'Tell something about yourself',
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (saved == true) {
      AppSnackbars.success(context, 'Profile updated');
    }
  }

  Future<void> _signOut(BuildContext context) async {
    final confirmed = await AppDialogs.confirm(
      context,
      title: 'Sign Out',
      message: 'Are you sure you want to sign out?',
      confirmText: 'Sign Out',
      destructive: true,
    );

    if (confirmed == true) {
      await context.read<AuthProvider>().signOut();
    }
  }
}
