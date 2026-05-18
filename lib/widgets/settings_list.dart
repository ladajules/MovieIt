import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movieit/models/user_preferences.dart';
import 'package:movieit/theme/app_colors.dart';
import 'package:movieit/widgets/universal_banner.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsList extends StatelessWidget {
  const SettingsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<UserPreferences>>(
      valueListenable: Hive.box<UserPreferences>('user_preferences').listenable(),
      builder: (context, box, _) {
        
        // Fetch current settings, or use your default values if none exist yet
        final prefs = box.get('current_prefs') ?? UserPreferences(
          notificationsEnabled: true,
        );

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSwitchTile(
              title: "Show in-app banners",
              value: prefs.notificationsEnabled,
              textColor: Colors.white,
              inactiveTrackColor: AppColors.plannerBg,
              inactiveThumbColor: AppColors.textMuted,
              onChanged: (val) {
                prefs.notificationsEnabled = val;
                box.put('current_prefs', prefs);
              },
            ),
            const SizedBox(height: 24),
            
            _buildReportBugButton(context),
          ],
        );
      },
    );
  }

  

  Widget _buildSwitchTile({
    required String title, 
    required bool value, 
    required Color textColor,
    required Color inactiveTrackColor,
    required Color inactiveThumbColor,
    required ValueChanged<bool> onChanged
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(color: textColor, fontSize: 14)),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.softPeriwinkle,
          activeTrackColor: AppColors.softPeriwinkle.withOpacity(0.3),
          inactiveThumbColor: inactiveThumbColor,
          inactiveTrackColor: inactiveTrackColor,
        ),
      ],
    );
  }

  Widget _buildReportBugButton(BuildContext context) {
    return TextButton.icon(
      onPressed: () async {
        
        final Uri emailUri = Uri(
          scheme: 'mailto',
          path: 'francesannagaeamutia@gmail.com', 
          query: 'subject=Bug Report - MovieIT',
        );
        if (await canLaunchUrl(emailUri)) {
          await launchUrl(emailUri);
        }
      },
      icon: const Icon(Icons.bug_report_rounded, color: AppColors.softPeriwinkle, size: 20),
      label: const Text("Report a Bug", style: TextStyle(color: Colors.white, fontSize: 14)),
      style: TextButton.styleFrom(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
      ),
    );
  }
}
