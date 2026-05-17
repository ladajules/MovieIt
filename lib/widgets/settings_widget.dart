
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movieit/theme/app_colors.dart';
import 'package:movieit/widgets/settings_list.dart';

class SettingsWidget extends StatelessWidget{
  const SettingsWidget({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 340,
        decoration: BoxDecoration(
          color: AppColors.headerBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.28),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.softPeriwinkle.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.settings_rounded,
                      color: AppColors.softPeriwinkle,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Settings",
                    style: GoogleFonts.poppins(
                      color: AppColors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: AppColors.cardBorder,
              height: 1,
              thickness: 1,
            ),
             Flexible(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 380),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: SettingsList(),
                ), //change this to 
              ),
            ),
          ],
        ),
      ),
    );
  }
}
